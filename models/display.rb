require_relative './year.rb'
require_relative './holiday_list.rb'
require 'date'

# Renders the supplied year class. Each month will be 20
# chars wide. (2 digits * 7 + spacing between each column)
# Header will be 86 characters wide (4 months + 2 chars padding between each)
class Display
  def initialize
    @highlights = TextHighlights.new
    @h_div = '  '
    @v_div = ' '
  end

  def render_year(year, holiday_list)
    raise ArgumentError 'Year must be a Year object' if year.class != Year
    puts justify(year.year, 86)
    months = year.months
    display_months(months, holiday_list)
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

  def display_months(months, holiday_list)
    until months.empty?
      these_months = months.shift(4)
      puts these_months.map { |month| justify(month.name, 22) }.join
      display_weekdays
      display_days(these_months, holiday_list)
      puts @v_div * 86
    end
  end

  def display_days(months, holiday_list)
    (0...find_longest_month(months)).each do |week_num|
      puts create_row(week_num, months, holiday_list)
    end
  end

  def create_row(week_num, months, holiday_list)
    months.map do |month|
      week = month.week(week_num)
      next ' ' * 20 + @h_div if week.nil?
      week.map { |day| create_day_entry(day, holiday_list) }.join(' ') + @h_div
    end.join
  end

  def create_day_entry(day, holiday_list)
    return '  ' unless day
    @highlights.highlight(day.day.to_s.rjust(2), holiday_list.holiday(day))
  end
end

# Handles date highlighting
class TextHighlights
  def initialize
    @highlights = {
      bold: "\e[1m%<value>s\e[0m",
      leap: "\e[1;32;47m%<value>s\e[0m",
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
