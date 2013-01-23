# note: this code is not being used anymore as Metaforce requires a
# user with ModifyAllData (superuser) priviledges.
require 'metaf'


describe Metaf do

  it 'Connects to SF instance using MetaForce' do
      env = 'emea_staging'
      client = subject.connect(env)
      client.describe[:metadata_objects].collect { |type| type[:xml_name] }
  end

  it 'Retrieves an XML File with Object / Field Definitions' do
  pending

  end

end
