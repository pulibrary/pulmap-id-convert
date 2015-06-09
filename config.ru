$LOAD_PATH.unshift './app'
$LOAD_PATH.unshift './app/models'
$LOAD_PATH.unshift './app/apis'

require 'setup'
require 'items'
require 'api'

# Setup Rack
run Rack::URLMap.new(
  '/'  => Rack::Static.new(Web,
                           urls: ['/'],
                           root: 'public/dist',
                           index: 'index.html'),
  '/api' => API.new
)
