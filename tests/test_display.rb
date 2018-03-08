require 'test/unit'
require_relative '../models/display.rb'

# Class used for testing the month class.
class TestDisplay < Test::Unit::TestCase
  @display = Display.new
  def test_private_methods
    assert_raise(NoMethodError) do
      @display.find_longest_month
    end
    assert_raise(NoMethodError) do
      @display.justify
    end
  end
end
