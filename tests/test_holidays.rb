require 'test/unit'
require_relative '../models/holiday_list.rb'

# Class used for testing the month class.
class TestHolidays < Test::Unit::TestCase

  def test_holiday_throws_on_improper_formatted_date
    assert_raise(ArgumentError) do
      Holiday.new('Christmas', 'asd')
    end
  end

  def test_holiday_takes_date
    holiday = Holiday.new('Christmas', Date.new(2018, 12, 25))
    assert_equal 'Christmas - December 25', holiday.to_s
  end

  def test_add_holiday_based_on_week
    holiday_list = HolidayList.new(Year.new(2018))
    holiday_list.add_holiday_based_on_week('Easter', 3, 1, 1)
    assert_equal 'Easter - April 2', holiday_list.holidays[0].to_s

    holiday_list.add_holiday_based_on_week('Thanksgiving', 9, 2, 1)
    assert_equal 'Thanksgiving - October 8', holiday_list.holidays[1].to_s
  end

  def test_is_holiday
    holiday_list = HolidayList.new(Year.new(2018))
    holiday_list.add_holiday('Remembrance Day', Date.new(2018, 11, 11))
    assert_equal :bold, holiday_list.holiday(Date.new(2018, 11, 11))
  end

  def test_is_not_holiday
    holiday_list = HolidayList.new(Year.new(2018))
    assert_equal :none, holiday_list.holiday(Date.new(2018, 12, 22))
  end

  def test_get_holiday_type
    holiday_list = HolidayList.new(Year.new(2000))
    holiday_list.add_holiday_based_on_week('Easter', 3, 1, 1)
    holiday_list.add_holiday_based_on_week('Thanksgiving', 9, 2, 1)
    holiday_list.add_holiday('Remembrance Day', Date.new(2000, 11, 11))
    holiday_list.add_holiday('Christmas Day', Date.new(2000, 12, 25))
    assert_equal :leap, holiday_list.holiday(Date.new(2000, 2, 29))
    assert_equal :friday13, holiday_list.holiday(Date.new(2000, 10, 13))
    assert_equal :bold, holiday_list.holiday(Date.new(2000, 12, 25))
    assert_equal :none, holiday_list.holiday(Date.new(2000, 1, 24))
  end
end
