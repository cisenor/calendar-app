require 'date'

# Object that holds all holidays
class HolidayList
  attr_reader :holidays
  def initialize(year)
    @holidays = []
    raise ArgumentError, 'Year parameter must be of type Year, got ' + year.class unless year.class == Year
    # Thanksgiving: 2nd Monday of October
    october = year.months[9]
    tday = october.nth_weekday_of_month(2, 1)
    @holidays << Holiday.new('Thanksgiving', '10-' + tday.to_s)

    # Easter: 1st Monday in April
    april = year.months[3]
    eday = april.nth_weekday_of_month(1, 1)
    @holidays << Holiday.new('Easter', '4-' + eday.to_s)
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
