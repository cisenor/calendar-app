require_relative 'models/month'
require_relative 'models/year'
require_relative 'views/console_view'
require_relative 'models/calendar_entry_store'
require_relative 'models/console'
require_relative 'models/markup'
require_relative 'views/html_view'
require_relative 'views/erb_view'
require_relative 'models/config'
require_relative 'models/json_parse'
require_relative 'utility/console_log'
require_relative 'models/calendar'
require 'optparse'

# Main app class.
class App
  def initialize(view)
    @display = ConsoleView.new
    @display = HTMLView.new 'index.html' if view == :web
    @log = ConsoleLog.new
    @user_input = Console.new
    @calendar = Calendar.new
    configure
    @view = PrintToERB.new('views/base_calendar.erb', 'dist/index.html')
  end

  def main
    prompt_for_year
    print_calendar
    app_loop
  end

  private

  def configure
    @config = Config.new(JSONParser)
    begin
      @config.load_configuration('config.json')
    rescue ArgumentError => arg_error
      @log.error(arg_error.message)
    end
  end

  def app_loop
    loop do
      @input = @user_input.prompt_for_action
      process_input
      break if @input == :exit
    end
  end

  ##
  # Prompt the user for a year, then populate the
  # instance vars year and holiday list with the new values
  def prompt_for_year
    @year = @user_input.prompt_for_input('Enter a year (four-digit number):').to_i
    unless @year.between?(1970, 3000)
      puts 'The year must be between 1970 & 3000'
      prompt_for_year
    end
    @calendar.switch_to_year(@year, @config)
  end

  def process_input
    case @input
    when :print_calendar then print_calendar
    when :print_calendar_dates then print_calendar_entries
    when :add_calendar_entry then add_calendar_entry
    when :change_year
      prompt_for_year
      print_calendar
    when :exit then @log.info 'Exiting...'
    else @log.info 'Invalid input.'
    end
  end

  def add_calendar_entry
    name = @user_input.prompt_for_input('Which holiday would you like to add? ')
    date = @user_input.prompt_for_input('What date does the holiday fall on? (mm-dd format) ')
    d = Date.strptime(date, '%m-%d')
    @calendar.calendar_entries.add_calendar_entry(name, d, :holiday)
    print_calendar
  end

  def print_calendar
    @view.render(@calendar)
  end

  def print_calendar_entries
    @display.log_calendar_entries(@calendar.calendar_entries)
  end
end

view = :web
OptionParser.new do |opts|
  opts.on('-C', '--console-only', 'Run in the console only.') do
    view = :console
  end
end.parse!

app = App.new view
app.main
