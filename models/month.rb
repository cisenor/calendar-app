# Defines a month object
class Month
  attr_reader :name
  def initialize(year, month)
  end

  def to_s
    @name
  end
end
