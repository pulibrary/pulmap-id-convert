require 'grape'
require 'json'

module APIHelpers  
  def get_item(id_type)
    item = Item.where(id_type => params[id_type]).first
    if item.blank?
      {}
    else
      item.to_hash
    end
  end
end

class API < Grape::API
  format :json

  helpers APIHelpers

  resource :items do
    desc "Returns all items"
    get do
      Item.all.map { |i| i.to_hash }
    end
  end

  resource :arks do

    desc "Returns list of ARKs"
    get do
       Item.all.reject{ |i| i.ark.blank? }.map{ |i| i.ark }
    end

    route_param :ark do
      desc "Returns any alternate ids related to the ARK"
      params do
        requires :ark, type: String, desc: "Archival Resouce Key (ARK) for item"
      end

      get do
        get_item(:ark)
      end
    end
  end

  resource :guids do

    desc "Returns list of guids"
    get do
       Item.all.reject{ |i| i.guid.blank? }.map{ |i| i.guid }
    end

    route_param :guid do
      desc "Returns any alternate ids related to the guid"
      params do
        requires :guid, type: String, desc: "FGDC guid"
      end

      get do
        get_item(:guid)
      end
    end
  end

  resource :images do

    desc "Returns list of image numbers"
    get do
       Item.all.reject{ |i| i.image.blank? }.map{ |i| i.image }
    end

    route_param :image do
      desc "Returns any alternate ids related to the image number"
      params do
        requires :image, type: String, desc: "Scanned map image number"
      end

      get do
        get_item(:image)
      end
    end
  end
end

class Web
 
  def initialize(options)
    @try = ['', *options.delete(:try)]
    @static = ::Rack::Static.new(
      lambda { [404, {}, []] }, 
      options)
  end
    
  def call(env)
    orig_path = env['PATH_INFO']
    # there's probably a better way to do this
    if orig_path.starts_with?('/api/')
        API.call(env)
    else
      found = nil
      @try.each do |path|
        resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
        break if 404 != resp[0] && found = resp
      end
      found or [404, {}, []]
    end
  end
  
end
