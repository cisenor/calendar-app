require_relative 'models/month.rb'
require_relative 'models/year.rb'
require_relative 'views/console_view.rb'
require_relative 'models/important_date_store.rb'
require_relative 'models/console.rb'
require_relative 'models/highlights'
require_relative 'views/html_view.rb'

# Main app class.
class App
  def initialize
    @display = HTMLView.new 'index.html'
    @user_input = Console.new
    @input = ''
    @year = 0
  end

  # Prompt the user for a year, then populate the instance vars year and holiday list with the new values
  def prompt_for_year
    year = @user_input.prompt_for_input('Enter a year (four-digit number):').to_i
    unless year.between?(1970, 3000)
      puts 'The year must be between 1970 & 3000'
      return prompt_for_year
    end
    @year = Year.new(year)
    @important_dates = ImportantDateStore.new(@year)
    add_initial_highlights
  end

  def add_initial_highlights
    @important_dates.calculate_important_date('Easter', 3, 1, 1, :holiday)
    @important_dates.calculate_important_date('Thanksgiving', 9, 2, 1, :holiday)
    @important_dates.mark_date('Remembrance Day', Date.new(@year.year, 11, 11), :holiday)
    @important_dates.mark_date('Christmas Day', Date.new(@year.year, 12, 25), :holiday)
    check_for_friday_thirteenth
    check_for_leap
  end

  def check_for_leap
    return unless @year.leap_year?
    @important_dates.mark_date('Leap Day', Date.new(@year.year, 2, 29), :leap)
  end

  def check_for_friday_thirteenth
    @year.months.each do |month|
      month.weeks.each do |week|
        day = week[5]
        next unless day
        @important_dates.mark_date('Friday the 13th', day, :friday13) if day.day == 13
      end
    end
  end

  def process_input
    case @input
    when :print_calendar
      print_calendar
    when :print_holidays
      print_holidays
    when :add_holiday
      add_holiday
    when :change_year
      prompt_for_year
      print_calendar
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
    @important_dates.mark_date(name, d)
    @display.print_calendar(@year, @important_dates)
  end

  def print_calendar
    @display.print_calendar(@year, @important_dates)
  end

  def print_holidays
    @display.render_holidays(@important_dates)
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
    @year = Year.new(2000)
    @important_dates = ImportantDateStore.new(@year)
    add_initial_highlights
    print_calendar
    # app_loop
  end
end

app = App.new
app.main
