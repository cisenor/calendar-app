require 'date'

# Object that holds all dates
class CalendarEntryStore
  attr_reader :dates
  def initialize(year)
    @dates = []
    raise ArgumentError, 'Year parameter must be of type Year, got ' + year.class unless year.class == Year
    @year = year
  end

  # Creates a holiday based on the nth weekday of the month.
  def calculate_calendar_date(name, month, occurrence, weekday, type)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(occurrence, weekday)
    add_calendar_entry(name, day, type)
  end

  def add_calendar_entry(name, date, type)
    raise ArgumentError unless date.class == Date
    entry = CalendarEntry.new(name, date, type)
    return if @dates.any? { |d| d == entry }
    
    # We're good
    @dates << entry
    sort
  rescue StandardError
    puts 'Can\'t create holiday with provided date: ' + date.to_s
  end

  def styling(date)
    day = get_calendar_entry_by_date date
    return day.type if day
    :none
  end

  def to_s
    "Calendar Entry Store containing #{dates.length} entries"
  end

  private

  def get_calendar_entry_by_date(date)
    @dates.find { |d| d.date == date }
  end

  def sort
    @dates.sort! { |a, b| a.date <=> b.date }
  end

  def date_has_entry?(date)
    @dates.any? { |h| h.date == date }
  end
end

# A single entry object
class CalendarEntry
  attr_reader :name
  attr_reader :date
  attr_reader :type
  def initialize(name, date, type)
    @name = name
    raise ArgumentError unless date.class == Date
    @date = date
    @type = type
  end

  def ==(other)
    @date == other.date && @name == other.name
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
