require_relative 'month.rb'
# A container for 12 month objects
class Year
  attr_reader :year
  attr_reader :is_leap
  attr_reader :months
  def initialize(in_year)
    @year = in_year
    @is_leap = (in_year % 4).zero?
    @months = (1..12).map { |m| Month.new(year, m) }
  end

  # Returns month at provided index. Index must be zero-based
  def month(index)
    raise RangeError, 'Provided index is outside the valid range of months: ' + index.to_s if index < 0 || index > 11
    @months[index]
  end
end
