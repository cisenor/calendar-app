require_relative './year.rb'
require_relative './holiday_manager.rb'

# Renders the supplied year class. Each month will be 20
# chars wide. (2 digits * 7 + spacing between each column)
# Header will be 86 characters wide (4 months + 2 chars padding between each)
class Renderer
  def self.horizontal_separator
    '  '
  end

  def self.vertical_separator
    ' '
  end

  def center(string, total)
    string.to_s.center total
  end

  def render_year(year)
    raise ArgumentError 'Year must be a Year object' if year.class != Year
    puts center year.year, 86
    months = year.months
    display_months(months)
  end

  def display_months(months)
    until months.empty?
      these_months = months[0, 4]
      months = months[4, 12]
      display_str = ''
      these_months.each do |month|
        display_str += center month.name, 22
      end
      puts display_str
      display_weekdays
      display_days these_months
      puts Renderer.vertical_separator * 86
    end
  end

  def find_longest_month(months)
    sorted_months = months.sort { |x, y| y.weeks.length <=> x.weeks.length }
    sorted_months.first.weeks.length
  end

  def display_days(months)
    longest_month = find_longest_month months
    (0...longest_month).each do |week_num|
      display_str = ''
      months.each do |month|
        if month.week(week_num).nil?
          display_str += ' ' * 20 + Renderer.horizontal_separator
        else
          display_values = month.week(week_num).map { |val| val.to_s.rjust 2 }
          display_str += display_values.join(' ') + Renderer.horizontal_separator
        end
      end
      puts display_str
    end
  end

  def display_weekdays
    wkdy_str = ''
    4.times do
      wkdy_str += 'Su Mo Tu We Th Fr Sa  '
    end
    print wkdy_str.rstrip
    puts ''
  end

  # Render all holidays as name - date
  def render_holidays(holiday_manager)
    raise ArgumentError if holiday_manager.class != HolidayManager
    holidays = holiday_manager.holidays
    puts 'Holidays:'
    holidays.each do |holiday|
      puts holiday
    end
  end

  def new_line
    puts ''
  end
end
