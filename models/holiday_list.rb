require 'date'

# Object that holds all holidays
class HolidayList
  attr_reader :holidays
  def initialize(year)
    @holidays = []
    raise ArgumentError, 'Year parameter must be of type Year, got ' + year.class unless year.class == Year
    @year = year
  end

  # Creates a holiday based on the nth weekday of the month.
  def calculate_important_date(name, month, nth, weekday, type)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(nth, weekday)
    mark_date(name, day, type)
  end

  def mark_date(name, date, type)
    raise ArgumentError unless date.class == Date
    # We're good
    @holidays << Holiday.new(name, date, type)
    sort
  rescue StandardError
    puts 'Can\'t create holiday with provided date: ' + date.to_s
  end

  def holiday(date)
    day = get_important_day_by_date date
    return day.type if day
    :none
    # return :bold if date_is_holiday?(date)
    # return :leap if date.month == 2 && date.day == 29
    # return :friday13 if date.friday? && date.day == 13
    # :none
  end

  private

  def get_important_day_by_date(date)
    @holidays.find { |d| d.date == date }
  end

  # Likely a utility for testing.
  def clear_holidays
    @holidays = []
  end

  def sort
    @holidays.sort! { |a, b| a.date <=> b.date }
  end

  def date_is_holiday?(date)
    @holidays.any? { |h| h.date == date }
  end

  def string_is_holiday?(date)
    @holidays.any? { |h| h.date.strftime('%m-%d') == date }
  end
end

# A single holiday object
class Holiday
  attr_reader :name
  attr_reader :date
  attr_reader :type
  def initialize(name, date, type)
    @name = name
    raise ArgumentError unless date.class == Date
    @date = date
    @type = type
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
