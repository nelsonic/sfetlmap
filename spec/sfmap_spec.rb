require 'sfmap'
require 'pp'
require 'config'

describe Sfmap do

  before(:all) do
    subject.origin_client
    subject.gdrive_session
    # subject.origin_org_objects
  end

  it 'Retrieves List of "Origin" Org SF Object' do
      # SF has Lots of SObjects! See:
      # http://www.salesforce.com/us/developer/docs/officetoolkit/Content/sforce_api_objects_list.htm
      origin_objects = subject.origin_org_objects
      expect(origin_objects.length).to be > 40
  end

  it 'Connects to Google Drive Checks Spreadsheet exists' do
      expect(subject.sheets.include? "#{subject.origin_org} Objects").to eq(true)
  end

  it 'Checks if the All SF Objects are in "Origin" Object Sheet' do
      origin_objects = subject.origin_org_objects
      sheet =  "#{subject.origin_org} Objects"
      col = 1
      empty_cell = subject.find_first_empty_cell_in_col(sheet,col)
      objects_in_sheet = subject.list_sf_obejcts_in_sheet(sheet,col)
      objects_not_in_sheet = subject.list_sf_objects_not_in_origin_sheet(origin_objects, objects_in_sheet)

      puts "Objects not in Sheet: #{objects_not_in_sheet.length}"
      puts "Number of Origin Objects in SF: #{origin_objects.length}"
      puts "Number of Objects in Sheet: #{objects_in_sheet.length}"

      if objects_not_in_sheet.size > 0
        # Try to update the list of objects in the Origin Sheet:
        subject.insert_origin_objects_into_sheet(sheet, col, empty_cell, objects_not_in_sheet)
        objects_in_sheet = subject.list_sf_obejcts_in_sheet(sheet,col)
        objects_not_in_sheet = subject.list_sf_objects_not_in_origin_sheet(origin_objects, objects_in_sheet)
      end
      expect(objects_not_in_sheet.size) .to eq(0)
  end

  it 'Updates each sheet in the Spreadsheet with any new fields' do
      sheets = subject.sheets
      # puts sheets
      origin_objects = subject.origin_org_objects
      # puts origin_objects
      # if the sheet name/title is an SF object try a "describe" on it.


  end

end
