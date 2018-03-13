require 'date'
require_relative './year.rb'
require_relative './holiday_list.rb'

# Outputs selected year's calendar to an HTML file.
class HTMLDisplay < Display
  def initialize(filename)
    @highlights = HTMLTextHighlights.new
    @filename = 'dist/' + filename
    File.delete @filename if File.file? @filename
  end

  def create_html_element(type, content, css_class = nil, css_id = nil)
    css_class = format " class=\"#{css_class}\"" if css_class
    css_id = format " id=\"#{css_id}\"" if css_id
    format "<#{type}#{css_class}#{css_id}>#{content}</#{type}>"
  end

  def render_year(year, holiday_list)
    raise ArgumentError 'Year must be a Year object.' if year.class != Year
    write create_html_element('div', year.year, 'centered header')
    months = year.months
    write '<div class="container">'
    display_months(months, holiday_list)
    write '</div></body></html>'
  end

  def display_months(months, holiday_list)
    until months.empty?
      this_month = months.shift
      write '<div class="month">'
      write create_html_element('div', this_month.name, 'month-name')
      week_header
      write_rows(this_month, holiday_list)
      write '</div>'
    end
  end

  def week_header
    weekdays = %w[Su Mo Tu We Th Fr Sa]
    write '<div class="week-header">'
    write weekdays.map { |day| create_html_element('span', day) }.join
    write '</div>'
  end

  def write_rows(month, holiday_list)
    month.weeks.map do |week|
      write '<div class="week">'
      week.each do |day|
        create_day_entry(day, holiday_list)
      end
      write '</div>'
    end
  end

  def create_day_entry(day, holiday_list)
    return write create_html_element('span', '') unless day
    write @highlights.highlight(day.day, holiday_list.holiday(day))
  end

  private

  def create_new_file
    File.open(@filename, 'w', 0644) do |file|
      file.puts '<html><head>'
      file.puts '<link rel="stylesheet" type="text/css" href="styles.css">'
      file.puts '</head><body>'
    end
  end

  def write(text)
    create_new_file unless File.file?(@filename)
    File.open(@filename, 'a') { |file| file.puts text }
  end
end
