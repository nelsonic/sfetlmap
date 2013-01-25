require 'config'
require 'google_drive'
require 'restforce'

class Sfmap
  @@conf =  EtlMapping::Config::config # instanciates config method
  @@gconf = @@conf['google']  # pull out google creds
  @@origin_env = 'emea_prod' # default "origin" sf org
  @@target_env = 'sbus'
  @@key = 'copy'      # default GDrive Spreadsheet key
  @@origin_org = "EMEA"
  @@target_org = "US"
  @@origin_client
  @@origin_org_objects = []
  @@target_org_objects = []
  @@gdrive_session
  @@spreadsheet
  @@sheets = []

  def gconf
    @@gconf
  end

  def origin_org
    @@origin_org
  end

  def target_org
    @@target_org
  end

  def restforce_connect(env)
    env ||= @@origin_env
    sfconf = @@conf[env]["salesforce"]   # pull out creds for the env instance
    @@client = Restforce.new :username => sfconf["user"],
      :password       => sfconf["password"],
      :security_token => sfconf["token"],
      :client_id      => sfconf["client_id"],
      :client_secret  => sfconf["client_secret"]
  end

  def origin_client
    @@origin_client = restforce_connect(@@origin_env)
  end

  def target_client
    @@target_client = restforce_connect(@@target_env)
  end

  def list_salesforce_objects(client)
      result = client.describe
      sf_objects = []
      result.each do |item|
        sf_objects << item.name
      end
      sf_objects
  end

  def origin_org_objects
    @@origin_org_objects = list_salesforce_objects(@@origin_client)
  end


  def gdrive_session
    @@gdrive_session = GoogleDrive.login(gconf["user"], gconf["password"])
  end


  def open_google_spreadsheet(key)
    @@gdrive_session ||= gdrive_session
    @@key = key ||= @@key
    sheet_key = gconf[key]
    @@spreadsheet = @@gdrive_session.spreadsheet_by_key(sheet_key)
  end

  def sheets
    @@spreadsheet ||= open_google_spreadsheet(@@key)
    @@spreadsheet.worksheets.each do |sheet|
      @@sheets << sheet.title
    end
    @@sheets
  end

  def list_origin_sf_obejcts_in_origin_sheet

  end



end
