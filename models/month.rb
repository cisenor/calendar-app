require 'date'
# Defines a month object
class Month
  attr_reader :year
  attr_reader :name
  attr_reader :last_day
  attr_reader :start_day

  def initialize(year, month)
    @year = year
    d = Date.civil(year, month, -1)
    @last_day = d.day
    @name = Date::MONTHNAMES[month]
  end

  def to_s
    @name
  end
end
