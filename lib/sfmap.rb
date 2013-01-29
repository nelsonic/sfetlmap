require 'config'
require 'google_drive'
require 'restforce'

class Sfmap
  attr_accessor :conf

  def key
    @key ||= 'copy'
  end

  def conf
    @conf ||=  EtlMapping::Config::config # instanciates config method
  end

  def gconf
    @conf  ||= conf
    @gconf ||= @conf['google']  # pull out google creds
  end

  def origin_org
    @origin_org ||= "EMEA"
  end

  def origin_env
    @origin_env ||= 'emea_prod' # default "origin" sf org
  end

  def target_org
    @target_org
  end

  def excluded_objects_patterns # this should be in a User-Editable SpreadSheet!!
    @excluded_objects_patterns ||= [
    "AccountHistory", "AccountPartner", "AccountShare", "AccountTag",
    "AccountTeamMember", "AccountTerritory", "ActivityHistory","AdditionalNumber",
    "AggregateResult", "Approval", "AssetTag","AssignmentRule", "Attachment",
    "Apex", "APXT_", "BrandTemplate", "CaseTeam", "CampaignMemberStatus",
    "CampaignShare","CampaignTag", "FISH_SYSTEM", "echosign", "ff", "Field_Trip",
    "IDE", "iformDemo", "natterbox", "__History","__Share", "__Tag","Period",
    "ProcessInstance", "SFGA", "shc__","TIMBASURVEYS", "TRIMDA", "tquilamobile",
    "Vote", "Zendesk"
  ]
  end

  def restforce_connect(env)
    env ||= @origin_env
    @conf ||= conf
    # puts "Env: #{env}"
    sfconf = @conf[env]["salesforce"]   # pull out creds for the env instance
    # puts "SF Conf: #{sfconf}"
    @client = Restforce.new :username => sfconf["user"],
      :password       => sfconf["password"],
      :security_token => sfconf["token"],
      :client_id      => sfconf["client_id"],
      :client_secret  => sfconf["client_secret"]
  end

  def origin_client
    @origin_client ||= restforce_connect(@origin_env)
  end

  # def target_client
    # @@target_client = restforce_connect(@@target_env)
  # end

  def list_salesforce_objects(client)
      # @excluded_objects_patterns ||= excluded_objects_patterns
      client ||= @client
      result = client.describe
      sf_objects = []
      result.each do |item|
        sf_objects << item.name.to_s
      end
      # puts "Number of SF Objects: #{sf_objects.length}"

      # exclude the unwanted objects/patterns using Regexp @@excluded_objects_patterns
      # http://stackoverflow.com/questions/9731649/match-a-string-against-multiple-paterns
      # re = Regexp.union(excluded_objects_patterns)
      # sf_objects.select{ |obj| !obj.match(re).nil? }.map{ |o| sf_objects.delete(o)}

      sf_objects
  end

  def origin_org_objects
    @origin_org_objects ||= list_salesforce_objects(@origin_client)
  end


  def gdrive_session
    @gdrive_session ||= GoogleDrive.login(gconf["user"], gconf["password"])
  end


  def open_google_spreadsheet(key)
    @gdrive_session ||= gdrive_session
    sheet_key = gconf[key]
    @spreadsheet ||= @gdrive_session.spreadsheet_by_key(sheet_key)
  end

  def spreadsheet
    @key ||= key
    @spreadsheet ||= open_google_spreadsheet(@key)
  end


  def sheets
    @sheets ||= []
    if @sheets.size == 0
      @key ||= key
      # puts "***** Key: #{@key} *****"
      @spreadsheet ||= open_google_spreadsheet(@key)
      @spreadsheet.worksheets.each do |sheet|
        @sheets << sheet.title
      end
    end
    @sheets
  end

  def find_worksheet_by title
    @spreadsheet ||= spreadsheet
    @spreadsheet.worksheets.find {|ws| ws.title == title}
  end

  def origin_sheet sheet_name
    @origin_sheet ||= find_worksheet_by sheet_name
  end

  def list_sf_obejcts_in_sheet(ws,column)
    origin_objects_in_sheet = []
    i = 1
    # first_empty_cell =  find_first_empty_cell_in_col(sheet_name,column)
    until i > ws.max_rows
      i = i + 1
      origin_objects_in_sheet <<  ws[i, column]
    end
    origin_objects_in_sheet.reject! { |c| c.empty? }
    origin_objects_in_sheet.delete("#{@origin_org} org")
    origin_objects_in_sheet.delete("Object")
    # puts i, origin_objects_in_sheet.length
    origin_objects_in_sheet
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

   def insert_origin_objects_into_sheet(ws, column, objects_to_add)
    empty_cell = find_first_empty_cell_in_col(ws,column)
    objects_to_add.each { |obj|
      # puts "Cell: #{empty_cell} | Obj: #{obj}"
      ws[empty_cell, column] = obj.to_s
      empty_cell = empty_cell + 1
    }
    ws.save()
   end

   # Updating the Individual Sheets is a bit more Complex than it needed to be.
   # Some sheets have the Field name colum in the 2nd column others in the 3rd/4th
   # so our script needs to "learn" which column is for which data
   # field_name_col, field_type_col, field_default_col
   # the function will take the sheet and a hash of fields as parameters
   # we recycle find_first_empty_cell method

   def find_column_number_by_name_in_sheet(ws,col_name)
      across = 1
      down   = 1
      until ws[down,across] == col_name || down == ws.num_rows
        if(across == 10 ) # ws.num_cols) # max columns in sheet
          across = 1         # reset column index to 1
          down   = down + 1  # increment row count
        else
          across = across + 1 # check next column
        end
      end
      if down == ws.num_rows
      end
      across # i.e. return the column index
   end

   def list_obejct_fields_in_sheet(ws,column)
    object_fields = []
    i = 1
    empty_cell = find_first_empty_cell_in_col(ws,column)
    until i > ws.num_rows
      i = i + 1
      object_fields << ws[i, column] # field_name
    end
    object_fields.reject! { |c| c.empty? }
    # puts i,    origin_objects_in_sheetlength
    object_fields
   end

   def find_first_empty_cell_in_col(ws,column)
    i = 4 # data usually only starts on 4th row
    empty_cell = 0
    until empty_cell > 0 # && (empty_cell + 2).to_s.strip.length == 0
      cell = ws[i, column]
      if cell.to_s.strip.length == 0 and ws[i+1, column].to_s.strip.length == 0 and ws[i+2, column].to_s.strip.length == 0
        empty_cell = i
      end
      i = i + 1
    end
    # puts "First Empty Cell = #{empty_cell}"
    empty_cell
  end

  def sheets_to_update
    @sheets_to_update = []
    @origin_org_objects ||= origin_org_objects
    @sheets ||= sheets
    @sheets.each { |sheet|
      if @origin_org_objects.include? sheet
        @sheets_to_update << sheet
      end
    }
    @sheets_to_update
  end




end
