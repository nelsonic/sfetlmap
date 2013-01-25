require 'sfmap'
require 'pp'
require 'config'

describe Sfmap do

  before(:all) do
    subject.origin_client
    subject.gdrive_session
  end

  it 'Retrieves List of "Origin" Org SF Object' do
      # SF has Lots of SObjects! See:
      # http://www.salesforce.com/us/developer/docs/officetoolkit/Content/sforce_api_objects_list.htm
      expect(subject.origin_org_objects.length).to be > 40
  end

  it 'Connects to Google Drive Checks Spreadsheet exists' do
      expect(subject.sheets.include? "#{subject.origin_org} Objects").to eq(true)
  end

  it 'Checks if the All SF Objects are in "Origin" Object Sheet' do
      object_not_present = []


  end

end
