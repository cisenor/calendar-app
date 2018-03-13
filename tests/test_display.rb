require 'test/unit'
require_relative '../models/console_view.rb'
require_relative '../models/html_view.rb'
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
    display = HTMLView.new('filename')
    test = display.send(:create_html_element, 'div', 'content', 'test-class', 'test-id')
    assumed = '<div class="test-class" id="test-id">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_with_id
    display = HTMLView.new('filename')
    test = display.send(:create_html_element, 'div', 'content', nil, 'test-id')
    assumed = '<div id="test-id">content</div>'
    assert_equal assumed, test
  end

  def test_html_display_plain_span
    display = HTMLView.new('filename')
    test = display.send(:create_html_element, 'span', 'content')
    assumed = '<span>content</span>'
    assert_equal assumed, test
  end
end
