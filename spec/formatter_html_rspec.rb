require 'test/unit'
require_relative '../models/formatters/console'
require_relative '../models/formatters/html'
# Test the API for the formatters
RSpec.describe FormatHTML, '#center' do
  context 'Given text "center"' do
    it 'formats the word "center" to be in the center of the line' do
      f = FormatHTML.new
      centered_text = f.center('center')
      expect(centered_text).to eq '<span class="centered">center</span>'
    end
  end
end

RSpec.describe FormatHTML, '#get_markup_block' do
  context 'Given the word "block"' do
    it 'returns the word "block" with a new-line attached' do
      f = FormatHTML.new
      div = f.get_markup_block('block')
      expect(div).to eq '<div>block</div>'
    end
  end
end

