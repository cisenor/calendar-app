require 'test/unit'
require_relative '../models/month.rb'

# Class used for testing the month class.
class TestMonth < Test::Unit::TestCase
  def test_month_created
    month = Month.new(2001, 1)
    assert_equal 'January', month.name
    assert_equal 2001, month.year
    assert_equal 31, month.last_day
  end
end
