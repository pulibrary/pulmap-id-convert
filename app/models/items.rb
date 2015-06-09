require 'sequel'

# Holds ids for map or gis objects.
class Item < Sequel::Model
  Sequel.extension :pagination
end
