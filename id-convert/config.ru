$:.unshift "./app"

require 'setup'
require 'models'
require 'api'

# Setup Rack
run Rack::URLMap.new( {
  "/"    => Rack::Static.new(Web, :urls => ["/"], :root => "public/dist", :index => 'index.html'),
  "/api" => API.new                          
})