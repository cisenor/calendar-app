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

  def test_scary
    @display = Display.new
    raw = 'test'
    # Use send to test private methods.
    dtext = @display.send(:make_scary_if_friday_13, raw, Date.new(2018, 7, 13))
    assert_equal "\e[41mtest\e[0m", dtext
  end

  def test_not_scary
    @display = Display.new
    raw = 'test'
    dtext = @display.send(:make_scary_if_friday_13, raw, Date.new(2018, 7, 12))
    assert_equal 'test', dtext
  end

end
