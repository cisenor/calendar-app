require 'date'
require_relative '../models/year.rb'
require_relative '../models/holiday_list.rb'

# Outputs selected year's calendar to an HTML file.
class HTMLView < ConsoleView
  def initialize(filename)
    @highlights = HTMLTextHighlights.new
    @filename = 'dist/' + filename
  end

  def print_calendar(year, holiday_list)
    raise ArgumentError 'Year must be a Year object.' if year.class != Year
    create_new_file
    write create_html_element('div', year.year, 'centered header')
    write create_html_element('div', create_months(year.months, holiday_list), 'container')
    end_file
  end

  private

  def create_months(months, holiday_list)
    months.map do |this_month|
      month_str = create_html_element('div', this_month.name, 'month-name')
      month_str << week_header if week_header
      month_str << create_weeks(this_month, holiday_list)
      create_html_element('div', month_str, 'month')
    end.join
  end

  # Create the day element. Either a 1-2 digit number with appropriate highlights
  # or an empty span element
  def create_day_entry(day, holiday_list)
    return create_html_element('span', '') unless day
    @highlights.highlight(day.day, holiday_list.holiday(day))
  end

  def week_header
    weekdays = %w[Su Mo Tu We Th Fr Sa]
    header_str = weekdays.map { |day| create_html_element('span', day) }.join
    create_html_element('div', header_str, 'week-header')
  end

  def end_file
    write '</body></html>'
  end

  def create_weeks(month, holiday_list)
    month.weeks.map do |week|
      week_str = week.map do |day|
        create_day_entry(day, holiday_list)
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
    File.open(@filename, 'w+', 0644) do |file|
      file.puts '<html><head>'
      file.puts '<link rel="stylesheet" type="text/css" href="styles.css">'
      file.puts '</head><body>'
    end
  end

  def write(text)
    fail IOError, 'The file has not yet been initialized' unless File.file? @filename
    File.open(@filename, 'a') { |file| file.puts text }
  end
end
