require_relative 'month.rb'
# A container for 12 month objects
class Year
  attr_reader :year
  attr_reader :is_leap
  attr_reader :months
  def initialize(in_year)
    @months = []
    @year = in_year
    @is_leap = (in_year % 4).zero?
    (1..12).each do |m|
      month = Month.new(year, m)
      @months << month
    end
  end

  # Returns month at provided index. Index must be zero-based
  def month(index)
    raise RangeError, 'Provided index is outside the valid range of months: ' + index.to_s if index < 0 || index > 11
    @months[index]
  end
end
