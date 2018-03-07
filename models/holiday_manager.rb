require 'date'

# Object that holds all holidays
class HolidayManager
  attr_reader :holidays
  def initialize
    @holidays = []
    @holidays << Holiday.new('Christmas', '12-25')
    @holidays << Holiday.new('Easter', '4-2')
    @holidays << Holiday.new('Remembrance Day', '11-11')
    @holidays << Holiday.new('Thanksgiving', '10-8')
    sort
  end

  def sort
    @holidays.sort! { |a, b| a.date <=> b.date }
  end

  def add_holiday(name, date)
    @holidays << Holiday.new(name, date)
  end
end

# A single holiday object
class Holiday
  attr_reader :name
  attr_reader :date
  def initialize(name, date)
    @name = name
    raise(ArgumentError.new, 'Date strings must be in mm-dd or mm-dd-yyyy format') if date.class == String && (date !~ /\d{1,2}-\d{1,2}-\d{4}/ && date !~ /\d{1,2}-\d{1,2}/)
    @date = Date.strptime(date, '%m-%d') if date.class == String && date =~ /\d{1,2}-\d{1,2}/
    @date = Date.strptime(date, '%m-%d-%y') if date.class == String && date =~ /\d{1,2}-\d{1,2}-\d{4}/
    @date = date if date.class == Date
  end

  def to_s
    @name.to_s + ' - ' + @date.strftime('%B %-d')
  end
end
