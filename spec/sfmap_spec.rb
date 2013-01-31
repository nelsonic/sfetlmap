require 'sfmap'
require 'config'

describe Sfmap do

  before(:all) do
      @origin_client = subject.origin_client
      @origin_objects =  subject.origin_org_objects
      @origin_ws = subject.find_worksheet_by "#{subject.origin_org} Objects"
      @origin_objects_in_sheet = subject.list_sf_obejcts_in_sheet(@origin_ws,1)
      @objects_not_in_sheet = subject.list_sf_objects_not_in_origin_sheet(@origin_objects, @origin_objects_in_sheet)
      @account_ws = subject.find_worksheet_by 'Account'
      @sheets = subject.sheets
  end

  it 'Retrieves List of "Origin" Org SF Object' do # Basic Test to check Connection
      # SF has Lots of SObjects! See:
      # http://www.salesforce.com/us/developer/docs/officetoolkit/Content/sforce_api_objects_list.htm
      expect(@origin_objects.length).to be > 40
  end

  it 'Connects to Google Drive Checks Spreadsheet exists' do
      expect(@sheets.include? "#{subject.origin_org} Objects").to eq(true)
  end

  it 'Checks if the All SF Objects are in "Origin" Object Sheet' do
      puts "Objects NOT in #{subject.origin_org} Objects Sheet: #{@objects_not_in_sheet.length}"
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
      expect(col_num).to eq(3)
  end

  it 'Find Fields in Account Sheet and Confirm Phone exists' do
      col_num = subject.find_column_number_by_name_in_sheet(@account_ws,'Field')
      expect(col_num).to eq(3)
      account_fields = subject.list_obejct_fields_in_sheet(@account_ws,col_num)
      expect(account_fields.include? 'Phone').to eq(true)
  end

  it 'Loop through the list of sheets and describe the SF Object' do
      ws = subject.find_worksheet_by 'US to EMEA Mappings'
      column = 5 # column where origin objects (sheets) listed
      sheets_to_update = subject.sheets_to_update(ws,column)
      sheets_to_update.delete("Activity") # Activity causes issues...
      sheets_to_update.each do |object|
        object_fields = subject.object_fields_to_update(object)
        subject.update_fields_for_object(object, object_fields)
      end
  end
end
