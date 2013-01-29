require 'sfmap'
require 'pp'
require 'config'

describe Sfmap do

  before(:all) do
      @origin_client = subject.restforce_connect(subject.origin_env)
      @origin_objects =  subject.origin_org_objects
      subject.gdrive_session
      @origin_ws = subject.find_worksheet_by "#{subject.origin_org} Objects"
      @origin_objects_in_sheet = subject.list_sf_obejcts_in_sheet(@origin_ws,1)
      @objects_not_in_sheet = subject.list_sf_objects_not_in_origin_sheet(@origin_objects, @origin_objects_in_sheet)
      @account_ws = subject.find_worksheet_by 'Account'
      @sheets = subject.sheets
  end

  it 'Retrieves List of "Origin" Org SF Object' do
      # SF has Lots of SObjects! See:
      # http://www.salesforce.com/us/developer/docs/officetoolkit/Content/sforce_api_objects_list.htm
      expect(@origin_objects.length).to be > 40
  end

  it 'Connects to Google Drive Checks Spreadsheet exists' do
      expect(subject.sheets.include? "#{subject.origin_org} Objects").to eq(true)
  end

  it 'Checks if the All SF Objects are in "Origin" Object Sheet' do
      puts "Objects not in Sheet: #{@objects_not_in_sheet.length}"
      puts "Number of Origin Objects in SF: #{@origin_objects.length}"
      puts "Number of Objects in Sheet: #{@origin_objects_in_sheet.length}"

      if @objects_not_in_sheet.size > 0
        # Try to update the list of objects in the Origin Sheet:
        subject.insert_origin_objects_into_sheet(@origin_ws, 1, @objects_not_in_sheet)
        @origin_objects_in_sheet = subject.list_sf_obejcts_in_sheet(@origin_ws,1)
        @objects_not_in_sheet =
          subject.list_sf_objects_not_in_origin_sheet(@origin_objects, @origin_objects_in_sheet)
      end
      expect(@objects_not_in_sheet.size).to eq(0)
  end

  it 'Finds the Column where the Field Name is located in a Sheet' do
      col_num = subject.find_column_number_by_name_in_sheet(@account_ws,'Field')
      puts "Account 'Field' column is in #{col_num}"
      expect(col_num).to eq(3)
      # col_num = subject.find_column_number_by_name_in_sheet('Type',sheet_name)
      # expect(col_num).to eq(6)
      # col_num = subject.find_column_number_by_name_in_sheet('Default Value',sheet_name)
      # expect(col_num).to eq(7)
  end

  it 'Find Fields in Account Sheet and Confirm Phone exists' do
      col_num = subject.find_column_number_by_name_in_sheet(@account_ws,'Field')
      expect(col_num).to eq(3)
      account_fields = subject.list_obejct_fields_in_sheet(@account_ws,col_num)
      # puts account_fields
      expect(account_fields.include? 'Phone').to eq(true)

  end



  it 'Loop through the list of sheets and describe the SF Object' do

      ws = subject.find_worksheet_by 'US to EMEA Mappings'
      column = 5
      @sheets_to_update = subject.list_obejct_fields_in_sheet(ws,column)
      puts @sheets_to_update

      @sheets_to_update.each do |obj|
        puts "*** Updating #{obj} ***"
        ws = subject.find_worksheet_by obj
        field_col = col_num = subject.find_column_number_by_name_in_sheet(ws,'Field')
        object_fields_in_sheet = subject.list_obejct_fields_in_sheet(ws,field_col)
        obj_fields = {}
        result = @origin_client.describe(obj)
        result.fields.each do |item|
          if !object_fields_in_sheet.include? item.name
            obj_fields[item.name] = {"name"=> item.name,
                                    "type" => item.type,
                                    "default" => item.defaultValue }
          end
        end

        type_col    = subject.find_column_number_by_name_in_sheet(ws,'Type')
        default_col = subject.find_column_number_by_name_in_sheet(ws,'Default Value')
        empty_cell  = subject.find_first_empty_cell_in_col(ws,field_col)
        obj_fields.each do |key,value|
          puts " #{empty_cell} v: #{value['name']} t: #{value['type']} d: #{value['default']}"
          ws[empty_cell, field_col]   = value["name"]
          ws[empty_cell, type_col]    = value["type"]
          ws[empty_cell, default_col] = value["default"]
          empty_cell += 1
        end
        ws.save()
      end
  end

  it ' ' do
    # result = @origin_client.describe
    # puts result

  end

end
