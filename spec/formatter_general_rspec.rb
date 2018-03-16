require_relative '../models/formatters/console'
require_relative '../models/formatters/html'

def check_api(f)
  expect(f.respond_to?(:block)).to eq true
  expect(f.respond_to?(:center)).to eq true
  expect(f.respond_to?(:title_header)).to eq true
  expect(f.respond_to?(:month_header)).to eq true
  expect(f.respond_to?(:style_text)).to eq true
  expect(f.respond_to?(:block)).to eq true
  expect(f.respond_to?(:block)).to eq true
end
RSpec.describe FormatConsole, '#check API' do
  context 'Check the class to make sure it listens to the proper calls' do
    it '' do
      f = FormatConsole.new 86
      check_api(f)
    end
  end
end

RSpec.describe FormatHTML, '#check API' do
  context 'Check the class has the proper methods' do
    it '' do
      f = FormatHTML.new
      check_api(f)
    end
  end
end
