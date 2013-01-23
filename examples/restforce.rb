require 'pp'
require 'restforce'
# require File.expand_path("../../lib/config", __FILE__) #http://www.ruby-forum.com/topic/915456
require_relative '../lib/config' # http://stackoverflow.com/a/4965766/1148249

env = 'emea_prod'
conf =  EtlMapping::Config::config # instanciates config method in lib/config.rb
sfconf = conf[env]["salesforce"]   # pull out creds for the env instance

client = Restforce.new :username => sfconf["user"],
  :password       => sfconf["password"],
  :security_token => sfconf["token"],
  :client_id      => sfconf["client_id"],
  :client_secret  => sfconf["client_secret"]

# sobjects =
  result = client.describe('Task')
  result.fields.each do |field|
    print "#{field.name} - #{field.type}\n"
  end
