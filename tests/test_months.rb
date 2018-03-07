require 'test/unit'
require_relative '../models/month.rb'

# Class used for testing the month class.
class TestMonth < Test::Unit::TestCase
  def test_month_created
    month = Month.new(2018, 1)
    assert_equal 'January', month.name
    assert_equal 2018, month.year
    assert_equal 31, month.last_day
  end

  def test_weeks_start_mid_week
    month = Month.new(2018, 3)
    week = month.week 0
    assert_equal nil, week[0]
    assert_equal nil, week[1]
    assert_equal nil, week[2]
    assert_equal nil, week[3]
    assert_equal 1, week[4]
    assert_equal 2, week[5]
    assert_equal 3, week[6]
  end

  def test_weeks_start_sunday
    month = Month.new(2018, 3)
    week = month.week 1
    assert_equal 4, week[0]
    assert_equal 5, week[1]
    assert_equal 6, week[2]
    assert_equal 7, week[3]
    assert_equal 8, week[4]
    assert_equal 9, week[5]
    assert_equal 10, week[6]
  end
end
