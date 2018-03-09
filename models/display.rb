require_relative './year.rb'
require_relative './holiday_list.rb'
require 'date'

# Renders the supplied year class. Each month will be 20
# chars wide. (2 digits * 7 + spacing between each column)
# Header will be 86 characters wide (4 months + 2 chars padding between each)
class Display
  def self.horizontal_separator
    '  '
  end

  def self.vertical_separator
    ' '
  end

  def initialize
    @highlights = TextHighlights.new
  end

  def render_year(year, holiday_list)
    raise ArgumentError 'Year must be a Year object' if year.class != Year
    puts justify(year.year, 86)
    months = year.months
    display_months(months, holiday_list, year)
  end

  def display_all(year, holiday_list)
    system 'clear'
    raise ArgumentError, 'Year argument must be of type Year. Got ' + year.class.to_s unless year.class == Year
    render_year(year, holiday_list)
    render_holidays(holiday_list)
  end

  # Render all holidays as name - date
  def render_holidays(holiday_list)
    raise ArgumentError if holiday_list.class != HolidayList
    holidays = holiday_list.holidays
    puts ''
    puts 'Holidays:'
    holidays.each do |holiday|
      puts holiday
    end
  end

  def new_line
    puts ''
  end

  def write(input)
    puts input
  end

  private

  def bold_if_holiday(value, date, holiday_list)
    value = @highlights.highlight(value, :bold) if holiday_list.holiday?(date)
    value
  end

  def make_scary_if_friday_13(value, date)
    raise ArgumentError if date.class != Date
    return value unless date.day == 13
    value = @highlights.highlight(value, :friday13) if date.friday?
    value
  end

  def mark_as_leap_day(value)
    @highlights.highlight(value, :leap)
  end

  def justify(value, total)
    value.to_s.center total
  end

  def find_longest_month(months)
    sorted_months = months.sort { |x, y| y.weeks.length <=> x.weeks.length }
    sorted_months.first.weeks.length
  end

  def display_weekdays
    wkdy_str = ''
    4.times do
      wkdy_str += 'Su Mo Tu We Th Fr Sa  '
    end
    print wkdy_str.rstrip
    puts ''
  end

  def display_months(months, holiday_list, year_object)
    until months.empty?
      these_months = months[0, 4]
      months = months[4, 12]
      display_str = these_months.map { |month| justify(month.name, 22) }.join
      puts display_str
      display_weekdays
      display_days(these_months, holiday_list, year_object)
      puts Display.vertical_separator * 86
    end
  end

  def display_days(months, holiday_list, year)
    longest_month = find_longest_month months
    (0...longest_month).each do |week_num|
      display_str = months.map do |month|
        week = month.week(week_num)
        next ' ' * 20 + Display.horizontal_separator if week.nil?
        week.map do |day|
          str_val = day.to_s.rjust 2
          next str_val unless day
          @highlights.highlight(str_val, holiday_list.holiday(Date.new(year.year, month.month, day)))
        end.join(' ') + Display.horizontal_separator
      end.join
      puts display_str
    end
  end
end

# Handles date highlighting
class TextHighlights
  def initialize
    @highlights = {
      bold: "\e[1m%<value>s\e[0m",
      leap: "\e[0;32;47m%<value>s\e[0m",
      friday13: "\e[41m%<value>s\e[0m",
      none: '%<value>s'
    }
  end

  def highlight(value, key)
    output = @highlights.fetch(key)
    return key unless output
    format output, value: value
  end
end
