require 'test/unit'
require_relative '../models/display.rb'
require_relative '../models/HTML_display.rb'
# Class used for testing the month class.
class TestFileIO < Test::Unit::TestCase
  def test_file_write
    filename = 'testing.html'
    display = HTMLDisplay.new filename
    display.send(:write, 'testing')
    File.open(filename, 'r') { |file| assert_equal "testing\n", file.gets }
  end
end
