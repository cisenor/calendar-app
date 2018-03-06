# A container for 12 month objects
class Year
  attr_reader :year
  attr_reader :is_leap
  attr_reader :months
  def initialize(year)
    @months = []
    @year = year
    @is_leap = (year.to_i % 4).zero?
    (1..12).each do |m|
      month = Month.new(year, m)
      @months << month
    end
  end
end
