require_relative 'models/month.rb'
require_relative 'models/year.rb'
require_relative 'models/console_view.rb'
require_relative 'models/holiday_list.rb'
require_relative 'models/console.rb'
require_relative 'models/highlights'
require_relative 'models/html_view.rb'

# Main app class.
class App
  def initialize
    @display = HTMLView.new('index.html')
    @user_input = Console.new
    @input = ''
    @year = 0
  end

  # Prompt the user for a year, then populate the instance vars year and holiday list with the new values
  def prompt_for_year
    year = @user_input.prompt_for_input('Enter a year (four-digit number):')
    year = year.to_i
    unless year.between?(1970, 3000)
      puts 'The year must be between 1970 & 3000'
      return prompt_for_year
    end
    @year = Year.new(year)
    @holiday_list = HolidayList.new(@year)
    add_initial_highlights
  end

  def add_initial_highlights
    @holiday_list.add_holiday_based_on_week('Easter', 3, 1, 1)
    @holiday_list.add_holiday_based_on_week('Thanksgiving', 9, 2, 1)
    @holiday_list.add_holiday('Remembrance Day', Date.new(@year.year, 11, 11))
    @holiday_list.add_holiday('Christmas Day', Date.new(@year.year, 12, 25))
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
    d = Date.strptime(date, '%m-%d')
    @holiday_list.add_holiday(name, d)
    @display.print_calendar(@year, @holiday_list)
  end

  def display_year
    @display.print_calendar(@year, @holiday_list)
  end

  def display_holidays
    @display.render_holidays(@holiday_list)
  end

  def app_loop
    loop do
      @input = @user_input.prompt_for_action
      process_input
      break if @input == :exit
    end
  end

  def main
    # prompt_for_year
    @year = Year.new(2011)
    @holiday_list = HolidayList.new(@year)
    add_initial_highlights
    display_year
    # app_loop
  end
end

app = App.new
app.main
