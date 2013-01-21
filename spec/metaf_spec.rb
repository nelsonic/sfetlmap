# require 'spec_helper'
# require 'mapping_doc'
require 'metaf'

describe Metaf do

  it 'Connects to SF instance using MetaForce' do
      env = 'emea'
      client = subject.connect(env)
      client.describe[:metadata_objects].collect { |type| type[:xml_name] }
  end

  it 'Retrieves an XML File with Object / Field Definitions' do
  pending

  end

end
