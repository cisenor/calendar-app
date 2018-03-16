require_relative '../models/formatters/console'
require_relative '../models/formatters/html'

# Test the API for the formatters
RSpec.describe FormatConsole, '#center' do
  context 'Given the word "center"' do
    it 'formats the word "center" to be in the center of the line' do
      f = FormatConsole.new 86
      centered_text = f.center('center')
      forty_spaces = ' ' * 40
      expect(centered_text).to eq "#{forty_spaces}center#{forty_spaces}"
    end
  end
end

RSpec.describe FormatConsole, '#get_markup_block' do
  context 'Given the word "block"' do
    it 'returns the word "block" in a div element' do
      f = FormatConsole.new 86
      div = f.block('block')
      expect(div).to eq "block\n"
    end
  end
end

RSpec.describe FormatConsole, '#title_header' do
  context 'Given the word "center"' do
    it 'returns a centered text with a new line at the end' do
      f = FormatConsole.new 86
      txt = f.title_header 'center'
      forty_spaces = ' ' * 40
      expect(txt).to eq "#{forty_spaces}center#{forty_spaces}\n"
    end
  end
end

RSpec.describe FormatConsole, '#month_header' do
  context 'Given the word June' do
    it 'returns the text centered in the column' do
      f = FormatConsole.new 86
      txt = f.month_header 'June'
      eight_spaces = ' ' * 8
      expect(txt).to eq "#{eight_spaces}June#{eight_spaces}"
    end
  end
end
