require 'rubygems'
require 'json'

##
# Parse JSON into a hash
class JSONParser
  def parse(string)
    json_hash = JSON.parse(string)
  end
end
