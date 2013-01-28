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
  @@target_org_objects = []
  @@gdrive_session
  @@spreadsheet
  @origin_sheet
  @@sheets = []
  @@excluded_objects_patterns = [
    "AccountHistory", "AccountPartner", "AccountShare", "AccountTag","AccountTeamMember",
    "AccountTerritory", "ActivityHistory","AdditionalNumber", "AggregateResult", "Approval",
    "AssetTag","AssignmentRule", "Attachment",
    "Apex", "APXT_", "BrandTemplate", "CaseTeam",
    "CampaignMemberStatus","CampaignShare","CampaignTag",
    "FISH_SYSTEM", "echosign", "ff", "Field_Trip",
    "IDE", "iformDemo", "natterbox",
    "__History","__Share", "__Tag",
    "Period","ProcessInstance",
    "SFGA", "shc__",
    "TIMBASURVEYS", "TRIMDA", "tquilamobile", "Vote", "Zendesk"
  ]


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
        sf_objects << item.name.to_s
      end
      # puts "Number of SF Objects: #{sf_objects.length}"

      # exclude the unwanted objects/patterns using Regexp @@excluded_objects_patterns
      # http://stackoverflow.com/questions/9731649/match-a-string-against-multiple-paterns
      re = Regexp.union(@@excluded_objects_patterns)
      sf_objects.select{ |obj| !obj.match(re).nil? }.map{ |o| sf_objects.delete(o)}

      sf_objects
  end

  def origin_org_objects
    @origin_org_objects ||= list_salesforce_objects(@@origin_client)
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

  def spreadsheet
    @@spreadsheet = open_google_spreadsheet(@@key)
  end


  def sheets
    @@spreadsheet ||= open_google_spreadsheet(@@key)
    @@spreadsheet.worksheets.each do |sheet|
      @@sheets << sheet.title
    end
    @@sheets
  end

  def find_worksheet_by title
    spreadsheet.worksheets.find {|ws| ws.title == title}
  end

  def origin_sheet sheet_name
    @origin_sheet ||= find_worksheet_by sheet_name
  end

  def list_sf_obejcts_in_sheet(sheet_name,column)
    @origin_sheet ||= origin_sheet sheet_name
    origin_objects_in_sheet = []
    i = 1
    first_empty_cell =  find_first_empty_cell_in_col(sheet_name,column)
    until i > first_empty_cell
      i = i + 1
      origin_objects_in_sheet <<  object = @origin_sheet[i, column]
    end
    origin_objects_in_sheet.reject! { |c| c.empty? }
    origin_objects_in_sheet.delete("#{@@origin_org} org")
    origin_objects_in_sheet.delete("Object")
    # puts i, origin_objects_in_sheet.length
    origin_objects_in_sheet
  end

  def find_first_empty_cell_in_col(sheet_name,column)
    @origin_sheet ||= origin_sheet sheet_name
    i = 4 # data usually only starts on 4th row
    empty_cell = 0
    until empty_cell > 0
      cell = @origin_sheet[i, column]
      if cell.to_s.strip.length == 0
        empty_cell = i
      end
      i = i + 1
    end
    # puts "First Empty Cell = #{empty_cell}"
    empty_cell
  end

  def list_sf_objects_not_in_origin_sheet(origin_objects, objects_in_sheet)
    origin_objects_not_in_sheet = []
    origin_objects.each do |object|
      if(objects_in_sheet.include? object)
          # object is present do nothing.
      else
        origin_objects_not_in_sheet << object
      end
    end
    origin_objects_not_in_sheet
  end

   def insert_origin_objects_into_sheet(sheet_name, column, empty_cell, objects_to_add)
    @origin_sheet ||= origin_sheet sheet_name
    objects_to_add.each { |obj|
      # puts "Cell: #{empty_cell} | Obj: #{obj}"
      @origin_sheet[empty_cell, column] = obj.to_s
      empty_cell = empty_cell + 1
    }
    @origin_sheet.save()
   end

end
