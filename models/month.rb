# Defines a month object
class Month
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end
