require 'sequel'

class Item < Sequel::Model
  Sequel.extension :pagination
end
