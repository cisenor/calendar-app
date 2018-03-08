require_relative 'models/month.rb'
require_relative 'models/year.rb'
require_relative 'models/display.rb'
require_relative 'models/holiday_list.rb'
require_relative 'models/console.rb'

@display = Display.new
@holiday_list = HolidayList.new
@console = Console.new
@input = ''
@year = 0

def prompt_for_year
  year = @console.prompt_for_input('Enter a year (four-digit number):')
  if year.to_i < 2000 || year.to_i > 3000
    puts 'The year must be between 2000 & 3000'
    return prompt_for_year
  end
  year.to_i
end

def process_input
  case @input
  when :display_year
    display_year
  when :display_holidays
    display_holidays
  when :add_holiday
    add_holiday
  when :change_year
    @year = prompt_for_year
    display_year
  when :exit
    @display.write('Exiting...')
  else
    @display.write('Invalid input.')
  end
end

def add_holiday
  name = @console.prompt_for_input('Which holiday would you like to add? ')
  date = @console.prompt_for_input('What date does the holiday fall on? (mm-dd format) ')
  @holiday_list.add_holiday(name, date)
  @holiday_list.sort
  @display.render_holidays(@holiday_list)
end

def display_year
  @display.display_all(@year, @holiday_list)
end

def display_holidays
  @display.render_holidays(@holiday_list)
end

def app_loop
  until @input == :exit
    @display.new_line
    @input = @console.prompt_for_action('Commands: Show full year (Y), Change year (C), View holidays (H), Add holiday (A), Exit (X):')
    process_input
  end
end

def main
  @year = prompt_for_year
  display_year
  app_loop
end

main
