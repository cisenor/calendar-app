require_relative '../models/year'
require_relative '../models/calendar_entry_store'
require_relative '../models/markup'
require 'date'

# Renders the supplied year class. Each month will be 20
# chars wide. (2 digits * 7 + spacing between each column)
# Header will be 86 characters wide (4 months + 2 chars padding between each)
class ConsoleView
  def initialize
    @markup = ConsoleMarkup.new
    @h_div = '  '
    @v_div = ' '
  end

  def print_calendar(year, calendar_entries)
    system 'clear'
    raise ArgumentError, 'Year argument must be of type Year. Got ' + year.class.to_s unless year.class == Year
    render_year(year, calendar_entries)
    print_calendar_entries(calendar_entries)
  end

  # Render all holidays as name - date
  def print_calendar_entries(calendar_entries)
    raise ArgumentError if calendar_entries.class != CalendarEntryStore
    entries = calendar_entries.holidays
    puts ''
    puts 'Holidays:'
    entries.each do |entry|
      puts entry
    end
  end

  def write(input)
    puts input
  end

  private

  def new_line
    puts ''
  end

  def render_year(year, calendar_entries)
    raise ArgumentError 'Year must be a Year object' if year.class != Year
    puts justify(year.year, 86)
    months = year.months
    display_months(months, calendar_entries)
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

  def display_months(months, calendar_entries)
    until months.empty?
      these_months = months.shift(4)
      puts these_months.map { |month| justify(month.name, 22) }.join
      display_weekdays
      display_days(these_months, calendar_entries)
      puts @v_div * 86
    end
  end

  def display_days(months, calendar_entries)
    (0...find_longest_month(months)).each do |week_num|
      puts create_row(week_num, months, calendar_entries)
    end
  end

  def create_row(week_num, months, calendar_entries)
    months.map do |month|
      week = month.weeks[week_num]
      next ' ' * 20 + @h_div unless week
      week.map { |day| create_day_entry(day, calendar_entries) }.join(' ') + @h_div
    end.join
  end

  def create_day_entry(day, calendar_entries)
    return '  ' unless day
    @markup.highlight(day.day.to_s.rjust(2), calendar_entries.styling(day))
  end
end
