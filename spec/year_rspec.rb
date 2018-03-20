require 'rspec'
require_relative '../models/year'

RSpec.describe Year, 'Initialization' do
  context 'Given a valid year' do
    it 'will return a year object, populated with 12 valid months' do
      y = Year.new 2001
      expect(y.months.size).to eq 12
      expect(y.months[1].name).to eq 'February'
      expect(y.months[1].last_day).to eq 28
    end
  end
end
