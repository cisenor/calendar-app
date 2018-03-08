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
  # Params
  # +name+:: The name of the holiday
  # +nth+:: The week number (zero-indexed)
  def create_holiday_based_on_week(name, month, nth, weekday)
    selected_month = @year.months[month]
    day = selected_month.nth_weekday_of_month(nth, weekday)
    @holidays << Holiday.new(name, (month + 1).to_s + '-' + day.to_s)
    sort
  end

  def sort
    @holidays.sort! { |a, b| a.date <=> b.date }
  end

  def add_holiday(name, date)
    @holidays << Holiday.new(name, date)
    sort
  end
end

# A single holiday object
class Holiday
  attr_reader :name
  attr_reader :date
  def initialize(name, date)
    @name = name
    if date.class == String
      @date = Date.strptime(date, '%m-%d') if date =~ /\d{1,2}-\d{1,2}/
      @date = Date.strptime(date, '%m-%d-%y') if date =~ /\d{1,2}-\d{1,2}-\d{4}/
    end
    @date = date if date.class == Date
    raise ArgumentError, 'Couldn\'t parse a date from ' + date.to_s if @date.nil?
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
