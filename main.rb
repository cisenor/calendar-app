require_relative 'models/month.rb'
require_relative 'utilities/command_line_utilities.rb'
require_relative 'models/year.rb'
require_relative 'models/renderer.rb'
require_relative 'models/holiday_list.rb'

@renderer = Renderer.new
@holiday_list = HolidayList.new
@input = ''
@year = 0

def prompt_for_year
  clear_console
  puts 'Enter a year (four-digit number):'
  year = gets.chomp
  if year.to_i < 1000 || year.to_i > 9999
    puts 'The year must be a four-digit number.'
    return prompt_for_year
  end
  puts 'You entered: ' + year
  year.to_i
end

def prompt_for_input
  puts 'Commands: Show full year (Y), Change year (C), View holidays (H), Add holiday (A), Exit (X)'
  @input = gets.chomp.upcase
end

def process_input
  case @input
  when 'Y'
    display_year
  when 'H'
    display_holidays
  when 'A'
    add_holiday
  when 'C'
    @year = prompt_for_year
    display_year
  when 'X'
    puts 'Exiting...'
  else
    puts 'I don\'t know what to do with that'
  end
end

def add_holiday
  clear_console
  print 'Which holiday would you like to add? '
  name = gets.chomp
  puts ''
  print 'What date does the holiday fall on? (mm-dd format) '
  date = gets.chomp
  @holiday_list.add_holiday(name, date)
  @holiday_list.sort
  clear_console
  @renderer.render_holidays(@holiday_list)
end

def display_year
  clear_console
  @renderer.render_year(Year.new(@year))
  @renderer.new_line
  @renderer.render_holidays(@holiday_list)
end

def display_holidays
  clear_console
  @renderer.render_holidays(@holiday_list)
end

def app_loop
  until @input == 'X'
    @renderer.new_line
    prompt_for_input
    process_input
  end
end

def main
  clear_console
  @year = prompt_for_year
  display_year
  app_loop
end

main
