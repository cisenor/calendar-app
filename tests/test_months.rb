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
    assert_equal [nil, nil, nil, nil, 1, 2, 3], week
  end

  def test_weeks_start_sunday
    month = Month.new(2018, 3)
    week = month.week 1
    assert_equal [4, 5, 6, 7, 8, 9, 10], week
  end

  def test_first_monday_of_month
    month = Month.new(2018, 3)
    assert_equal 5, month.nth_weekday_of_month(1, 1)
  end

  def test_third_saturday_of_month
    month = Month.new(2018, 3)
    assert_equal 17, month.nth_weekday_of_month(3, 6)
  end
end
