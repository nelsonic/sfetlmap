require 'pp'
require "rubygems"
require "google_drive"
require_relative '../lib/config' # http://stackoverflow.com/a/4965766/1148249

env = 'google'
conf =  EtlMapping::Config::config # instanciates config method in lib/config.rb
gconf = conf[env]  # pull out google creds

session = GoogleDrive.login(gconf["user"], gconf["password"])
sheet_key = gconf["copy"]
spreadsheet = session.spreadsheet_by_key(sheet_key)
sheets = []
spreadsheet.worksheets.each do |sheet|
  sheets << sheet.title
end

pp sheets
