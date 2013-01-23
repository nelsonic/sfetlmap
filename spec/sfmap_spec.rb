# note: this code is not being used anymore as Metaforce requires a
# user with ModifyAllData (superuser) priviledges.
require 'sfmap'
require 'pp'

describe Sfmap do

  before(:all) do
    @env = 'emea_prod'
    @client = subject.restforce_connect(@env)
  end

  it 'Connects to SF instance using Restforce' do
      puts "Salesforce Org: #{@env} | Client: #{@client}"
      # Check Task Object has a (Standard) field OwnerId:
      result  = @client.describe('Task')
      fields = []
      result.fields.each {|field| fields << field.name }
      expect(fields.include? "OwnerId").to be_true
  end

  it 'Retrieves JSON with of SF Object / Field Definitions' do
      result = @client.describe
      result_filename = "tmp/#{@env}_describe.txt"
      File.open(result_filename, 'w') { |f| f.write(result.to_s) }
      # pp result
  end


  it 'Connects to Google Drive Checks Spreadsheet exists' do
  pending

      sheet_key = gconf["copy"]
      spreadsheet = session.spreadsheet_by_key(sheet_key)
      expect(spreadsheet.worksheet.count).to be > 0

  end

end
