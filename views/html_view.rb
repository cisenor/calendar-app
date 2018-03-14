require 'date'
require_relative '../models/year.rb'
require_relative './console_view'
require_relative '../models/calendar_entry_store.rb'

##
# Outputs provided year's calendar to an HTML file.
class HTMLView < ConsoleView
  ##
  # +filename+ Name of the output file, located in the dist folder.
  def initialize(filename)
    @markup = HTMLMarkup.new
    @filename = 'dist/' + filename
  end

  ##
  # Prints the calendar to the HTML file, highlighting
  # any days that are also stored in the calendar entry store.
  def print_calendar(year, calendar_entry_store = nil)
    @calendar_entry_store = calendar_entry_store
    raise ArgumentError 'Year must be a Year object.' if year.class != Year
    create_new_file
    write create_html_element('div', year.year, 'centered header')
    months = create_months(year.months)
    write create_html_element('div', months, 'container')
    print_calendar_entries
    end_file
  end

  ##
  # Logs text to the console, not to the HTML file.
  def log(text)
    puts text
  end

  ##
  # Writes provided text to the initialized text file.
  def write(text)
    raise IOError, 'The file has not yet been initialized' unless File.file? @filename
    File.open(@filename, 'a') { |file| file.puts text }
  end

  ##
  # Render all holidays as name - date
  def print_calendar_entries
    days = @calendar_entry_store.dates.map(&:to_s)
    write create_html_element('div', 'Important Dates', 'header centered')
    write create_list(days)
  end

  private

  def create_list(array, css_class = nil)
    li = array.map { |item| create_html_element('li', item) }.join
    create_html_element('ul', li, css_class)
  end

  def create_months(months)
    months.map do |this_month|
      month_str = create_html_element('div', this_month.name, 'month-name')
      month_str << week_header
      month_str << create_weeks(this_month)
      create_html_element('div', month_str, 'month')
    end.join
  end

  # Create the day element. Either a 1-2 digit number with appropriate markup
  # or an empty span element
  def create_day_entry(day)
    return create_html_element('span', '') unless day
    markup = :none
    markup = @calendar_entry_store.styling(day) if @calendar_entry_store
    @markup.highlight(day.day, markup)
  end

  def week_header
    weekdays = %w[Su Mo Tu We Th Fr Sa]
    header_str = weekdays.map { |day| create_html_element('span', day) }.join
    create_html_element('div', header_str, 'week-header')
  end

  def end_file
    write '</body></html>'
  end

  def create_weeks(month)
    month.weeks.map do |week|
      week_str = (0..6).map do |day|
        create_day_entry(week[day])
      end.join
      create_html_element('div', week_str, 'week')
    end.join
  end

  def create_html_element(type, content, css_class = nil, css_id = nil)
    css_class = format " class=\"#{css_class}\"" if css_class
    css_id = format " id=\"#{css_id}\"" if css_id
    format "<#{type}#{css_class}#{css_id}>#{content}</#{type}>"
  end

  def create_new_file
    File.open(@filename, 'w+', 0o644) do |file|
      file.puts '<html><head>'
      file.puts '<link rel="stylesheet" type="text/css" href="styles.css">'
      file.puts '</head><body>'
    end
  end
end
