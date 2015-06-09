$LOAD_PATH.unshift './app'
$LOAD_PATH.unshift './app/models'
$LOAD_PATH.unshift './app/apis'

require 'rack/test'
require 'factory_girl'
require 'sequel'
require 'uuidtools'
require 'noid'

Sequel.connect("sqlite://#{Dir.pwd}/test.db")

require 'items'
require 'api'

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.mock_with :rspec
  config.expect_with :rspec
  config.formatter = :documentation
  config.order = 'random'
end
