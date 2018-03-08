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
    add_holiday('Remembrance Day', '11-11')
    add_holiday('Christmas Day', '12-25')
  end

  # Creates a holiday based on the nth weekday of the month.
  # Params
  # +name+:: The name of the holiday
  # +nth+:: The week number (zero-indexed)
  def add_holiday_based_on_week(name, month, nth, weekday)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(nth, weekday)
    add_holiday(name, (month + 1).to_s + '-' + day.to_s)
  end

  def sort
    @holidays.sort! { |a, b| a.date <=> b.date }
  end

  # Likely a utility for testing.
  def clear_holidays
    @holidays = []
  end

  def add_holiday(name, date)
    m, d = date.scan(/\d{1,2}/)
    raise ArgumentError if m.nil? || d.nil?
    month = @year.month(m.to_i - 1)
    raise ArgumentError unless month.valid_day? d

    # We're good
    @holidays << Holiday.new(name, date)
    sort
  rescue StandardError
    puts 'Can\'t create holiday with provided date: ' + date.to_s
  end
end

# A single holiday object
class Holiday
  attr_reader :name
  attr_reader :date
  def initialize(name, date)
    @name = name
    @date = Date.strptime(date, '%m-%d')
    raise ArgumentError, 'Couldn\'t parse a date from ' + date.to_s if @date.nil?
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
