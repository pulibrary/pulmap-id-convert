require 'grape'
require 'json'

# Helpers for id items API.
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

# Item API routing.
class API < Grape::API
  format :json

  helpers APIHelpers

  resource :items do
    desc 'Returns all items'
    get do
      Item.all.map(&:to_hash)
    end
  end

  resource :arks do
    desc 'Returns list of ARKs'
    get do
      Item.all.reject { |i| i.ark.blank? }.map(&:ark)
    end

    route_param :ark do
      desc 'Returns any alternate ids related to the ARK'
      params do
        requires :ark, type: String, desc: 'Archival Resouce Key (ARK) for item'
      end

      get do
        get_item(:ark)
      end
    end
  end

  resource :guids do
    desc 'Returns list of guids'
    get do
      Item.all.reject { |i| i.guid.blank? }.map(&:guid)
    end

    route_param :guid do
      desc 'Returns any alternate ids related to the guid'
      params do
        requires :guid, type: String, desc: 'FGDC guid'
      end

      get do
        get_item(:guid)
      end
    end
  end

  resource :images do
    desc 'Returns list of image numbers'
    get do
      Item.all.reject { |i| i.image.blank? }.map(&:image)
    end

    route_param :image do
      desc 'Returns any alternate ids related to the image number'
      params do
        requires :image, type: String, desc: 'Scanned map image number'
      end

      get do
        get_item(:image)
      end
    end
  end
end

# Class to return static files.
class Web
  def initialize(options)
    @try = ['', *options.delete(:try)]
    @static = ::Rack::Static.new(
      -> { [404, {}, []] },
      options)
  end

  def find
    found = nil
    @try.each do |path|
      resp = @static.call(env.merge!('PATH_INFO' => orig_path + path))
      break if resp[0] != 404 && found == resp
    end
    found || [404, {}, []]
  end

  def call(env)
    orig_path = env['PATH_INFO']
    if orig_path.starts_with?('/api/')
      API.call(env)
    else
      find
    end
  end
end
