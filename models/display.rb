require_relative './year.rb'
require_relative './holiday_list.rb'

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

  def justify(value, total)
    value.to_s.center total
  end

  def render_year(year, holiday_list)
    raise ArgumentError 'Year must be a Year object' if year.class != Year
    puts justify(year.year, 86)
    months = year.months
    display_months(months, holiday_list)
  end

  def display_months(months, holiday_list)
    until months.empty?
      these_months = months[0, 4]
      months = months[4, 12]
      display_str = ''
      these_months.each do |month|
        display_str += justify month.name, 22
      end
      puts display_str
      display_weekdays
      display_days(these_months, holiday_list)
      puts Display.vertical_separator * 86
    end
  end

  def find_longest_month(months)
    sorted_months = months.sort { |x, y| y.weeks.length <=> x.weeks.length }
    sorted_months.first.weeks.length
  end

  def display_days(months, holiday_list)
    longest_month = find_longest_month months
    (0...longest_month).each do |week_num|
      display_str = ''
      months.map do |month|
        if month.week(week_num).nil?
          display_str += ' ' * 20 + Display.horizontal_separator
        else
          display_values = month.week(week_num).map do |day|
            str_val = day.to_s.rjust 2
            bold_if_holiday(str_val, month.month, day, holiday_list)
          end
          display_str += display_values.join(' ') + Display.horizontal_separator
        end
      end
      puts display_str
    end
  end

  def bold_if_holiday(value, month, day, holiday_list)
    return value if day.nil?
    value = bold(value) if holiday_list.holiday?(month, day)
    value
  end

  def display_weekdays
    wkdy_str = ''
    4.times do
      wkdy_str += 'Su Mo Tu We Th Fr Sa  '
    end
    print wkdy_str.rstrip
    puts ''
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

  def bold(value)
    "\e[1m#{value}\e[0m"
  end

  def write(input)
    puts input
  end

  private :find_longest_month, :justify, :display_weekdays, :display_months, :bold_if_holiday
end
