require 'config'
# require 'google_drive'
# require 'sf_object'
require 'restforce'

class Sfmap

  def restforce_connect(env)
    conf =  EtlMapping::Config::config # instanciates config method in lib/config.rb
    sfconf = conf[env]["salesforce"]   # pull out creds for the env instance

    client = Restforce.new :username => sfconf["user"],
      :password       => sfconf["password"],
      :security_token => sfconf["token"],
      :client_id      => sfconf["client_id"],
      :client_secret  => sfconf["client_secret"]
  end

  def sf_client(env)


  end


end
