require 'config'
# require 'google_drive'
# require 'sf_object'
require 'metaforce'

class Metaf

  def connect(env)
      # env = 'emea'
      conf = EtlMapping::Config::config
      puts "SF User", conf[env]
      Metaforce.configuration.host = 'test.salesforce.com'
      client = Metaforce.new :username => conf[env]["salesforce"]["user"],
        :password => conf[env]["salesforce"]["password"],
        :security_token => conf[env]["salesforce"]["token"]
  end
end
