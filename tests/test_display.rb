require 'test/unit'
require_relative '../models/display.rb'

# Class used for testing the month class.
class TestDisplay < Test::Unit::TestCase
  def test_private_methods
    @display = Display.new
    assert_raise(NoMethodError) do
      @display.find_longest_month
    end
    assert_raise(NoMethodError) do
      @display.justify
    end
    assert_raise(NoMethodError) do
      @display.bold_if_holiday
    end
  end
end
