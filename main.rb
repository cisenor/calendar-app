require_relative 'models/month'
require_relative 'models/year'
require_relative 'views/console_view'
require_relative 'models/calendar_entry_store'
require_relative 'models/console'
require_relative 'models/markup'
require_relative 'views/html_view'
require_relative 'models/config'
require_relative 'models/json_parse'

# Main app class.
class App
  def initialize
    @display = ConsoleView.new  #HTMLView.new 'index.html'
    @user_input = Console.new
    @input = ''
    @year = 0
  end

  def main
    @config = Config.new(JSONParser)
    @config.load_configuration('config.json')
    prompt_for_year
    add_initial_markup
    print_calendar
    app_loop
  end

  private

  def app_loop
    loop do
      @input = @user_input.prompt_for_action
      process_input
      break if @input == :exit
    end
  end

  # Prompt the user for a year, then populate the instance vars year and holiday list with the new values
  def prompt_for_year
    year = @user_input.prompt_for_input('Enter a year (four-digit number):').to_i
    unless year.between?(1970, 3000)
      puts 'The year must be between 1970 & 3000'
      return prompt_for_year
    end
    @year = Year.new(year)
    @calendar_entries = CalendarEntryStore.new(@year)
    add_initial_markup
  end

  def add_initial_markup
    @config.calendar_entries.map do |entry|
      if entry.date
        d = Date.strptime(entry.date, '%m-%d')
        @calendar_entries.add_calendar_entry(entry.name, d, :holiday)
      else
        @calendar_entries.calculate_calendar_date(entry.name, entry.month, entry.nth, entry.weekday, :holiday)
      end
    end
    check_for_friday_thirteenth
    check_for_leap
  end

  def check_for_leap
    return unless @year.leap_year?
    leap_day = Date.new(@year.year, 2, 29)
    @calendar_entries.add_calendar_entry('Leap Day', leap_day, :leap)
  end

  def check_for_friday_thirteenth
    @year.months.each do |month|
      month.weeks.each do |week|
        day = week[5]
        next unless day && day.day == 13
        @calendar_entries.add_calendar_entry('Friday the 13th', day, :friday13)
      end
    end
  end

  def process_input
    case @input
    when :print_calendar then print_calendar
    when :print_calendar_dates then print_calendar_entries
    when :add_calendar_entry then add_calendar_entry
    when :change_year
      prompt_for_year
      print_calendar
    when :exit then @display.log 'Exiting...'
    else @display.log 'Invalid input.'
    end
  end

  def add_calendar_entry
    name = @user_input.prompt_for_input('Which holiday would you like to add? ')
    date = @user_input.prompt_for_input('What date does the holiday fall on? (mm-dd format) ')
    d = Date.strptime(date, '%m-%d')
    @calendar_entries.add_calendar_entry(name, d, :holiday)
    @display.print_calendar(@year, @calendar_entries)
  end

  def print_calendar
    @display.print_calendar(@year, @calendar_entries)
  end

  def print_calendar_entries
    @display.log_calendar_entries(@calendar_entries)
  end
end

app = App.new
app.main
