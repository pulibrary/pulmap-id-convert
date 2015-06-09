require 'yaml'
require 'sequel'

if File.exist?("#{Dir.pwd}/config/database.yml")
  config = YAML.load_file("#{Dir.pwd}/config/database.yml")
  Sequel.connect("sqlite://#{Dir.pwd}/#{config['database']}.db")
end
