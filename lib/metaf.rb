require 'config'
# require 'google_drive'
# require 'sf_object'
require 'metaforce'

class Metaf

  def connect(env)
      # env = 'emea'
      conf = EtlMapping::Config::config
      Metaforce.configuration.host = conf[env]["salesforce"]["login_url"] #'test.salesforce.com'
      puts "SF Env: ", conf[env], conf[env]["salesforce"],  Metaforce.configuration.host
      client = Metaforce.new :username => conf[env]["salesforce"]["user"],
        :password => conf[env]["salesforce"]["password"],
        :security_token => conf[env]["salesforce"]["token"]
  end
end
