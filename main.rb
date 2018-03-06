
require_relative 'models/month.rb'
require_relative 'utilities/command_line_utilities.rb'
def main
  clear_console
  month = Month.new('June')
  puts month.name
end

main
