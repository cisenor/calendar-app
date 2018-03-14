require 'test/unit'
require_relative '../views/console_view.rb'
require_relative '../views/html_view.rb'
# Class used for testing the month class.
class TestDisplay < Test::Unit::TestCase
  def test_private_methods
    @display = ConsoleView.new
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

  def test_html_display_with_id_and_class
    test = HTMLMarkup.new.get_markup_block('content', 'test-class')
    assumed = '<div class="test-class">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_with_class
    test = HTMLMarkup.new.get_markup_block('content','test-class')
    assumed = '<div class="test-class">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_plain_span
    test = HTMLMarkup.new.get_markup_inline('content')
    assumed = '<span>content</span>'
    assert_equal assumed, test
  end
end
