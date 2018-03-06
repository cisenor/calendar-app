require 'test/unit'
require_relative '../models/month.rb'

# Class used for testing the month class.
class TestMonth < Test::Unit::TestCase
  def test_month_created
    month = Month.new(2001, 1)
    assert_equal month.name, 'January'
    assert_equal month.year, 2001
    assert_equal month.last_day, 31
  end
end
