require_relative 'models/month.rb'
require_relative 'models/year.rb'
require_relative 'models/display.rb'
require_relative 'models/holiday_list.rb'
require_relative 'models/console.rb'

@display = Display.new
@user_input = Console.new
@input = ''
@year = 0

def prompt_for_year
  year = @user_input.prompt_for_input('Enter a year (four-digit number):')
  if year.to_i < 1970 || year.to_i > 3000
    puts 'The year must be between 1970 & 3000'
    return prompt_for_year
  end
  @year = Year.new(year.to_i)
  @holiday_list = HolidayList.new(@year)
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
    prompt_for_year
    display_year
  when :exit
    @display.write('Exiting...')
  else
    @display.write('Invalid input.')
  end
end

def add_holiday
  name = @user_input.prompt_for_input('Which holiday would you like to add? ')
  date = @user_input.prompt_for_input('What date does the holiday fall on? (mm-dd format) ')
  @holiday_list.add_holiday(name, date)
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
    @input = @user_input.prompt_for_action
    process_input
  end
end

def main
  prompt_for_year
  display_year
  app_loop
end

main
