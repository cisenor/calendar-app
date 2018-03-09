require 'date'

# Object that holds all holidays
class HolidayList
  attr_reader :holidays
  def initialize(year)
    @holidays = []
    raise ArgumentError, 'Year parameter must be of type Year, got ' + year.class unless year.class == Year
    @year = year
    add_holiday_based_on_week('Easter', 3, 1, 1)
    add_holiday_based_on_week('Thanksgiving', 9, 2, 1)
    add_holiday('Remembrance Day', Date.new(@year.year, 11, 11))
    add_holiday('Christmas Day', Date.new(@year.year, 12, 25))
  end

  # Creates a holiday based on the nth weekday of the month.
  def add_holiday_based_on_week(name, month, nth, weekday)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(nth, weekday)
    add_holiday(name, Date.new(@year.year, month + 1, day))
  end

  # Likely a utility for testing.
  def clear_holidays
    @holidays = []
  end

  def add_holiday(name, date)
    raise ArgumentError unless date.class == Date
    # We're good
    @holidays << Holiday.new(name, date)
    sort
  rescue StandardError
    puts 'Can\'t create holiday with provided date: ' + date.to_s
  end

  def holiday(date)
    return :bold if date_is_holiday?(date)
    return :leap if date.month == 2 && date.day == 29
    return :friday13 if date.friday? && date.day == 13
    :none
  end

  private

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
  def initialize(name, date)
    @name = name
    raise ArgumentError unless date.class == Date
    @date = date
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
