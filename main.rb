
require_relative 'models/month.rb'
require_relative 'utilities/command_line_utilities.rb'
require_relative 'models/year.rb'
require_relative 'models/renderer.rb'

def prompt_for_year
  puts 'Enter a year (four-digit number):'
  year = gets.chomp
  if year.to_i < 1000 || year.to_i > 9999
    puts 'The year must be a four-digit number.'
    return prompt_for_year
  end
  puts 'You entered: ' + year
end

def main
  clear_console
  y = 2001 # prompt_for_year
  year = Year.new(y)
  renderer = Renderer.new
  renderer.render_year(year)
end

main
