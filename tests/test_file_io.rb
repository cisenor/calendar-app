require 'test/unit'
require_relative '../models/console_view.rb'
require_relative '../models/html_view.rb'
# Class used for testing the month class.
class TestFileIO < Test::Unit::TestCase
  def test_file_write
    filename = 'testing.html'
    display = HTMLView.new filename
    display.send(:create_new_file)
    display.send(:write, 'testing')
    File.open('dist/' + filename, 'r') { |file| assert_equal "<html><head>\n", file.gets }
    File.delete('dist/' + filename)
  end

  def test_write_file_fails_when_not_opened
    filename = 'testing'
    display = HTMLView.new filename
    assert_raise IOError do
      display.send(:write, 'SuperTestMessage')
    end
  end
end
