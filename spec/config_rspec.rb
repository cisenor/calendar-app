require 'rspec'
require_relative '../models/config/json_parse'
require_relative '../models/config/config'

RSpec.describe Config, 'Can read config' do 
  context 'Given a JSON parser and a config path' do
    it 'will return a populated configuration object' do
      config = Config.new(JSONParser)
      config.load_configuration('./config.json')
      expect(config.calendar_entries).to_not be_nil
    end
  end
end

RSpec.describe Config, 'Parses calendar entries properly' do
  context 'Given a JSON parser and a config path' do
    it 'will return a config object with valid calendar entries' do
      config = Config.new JSONParser
      config.load_configuration './config.json'
      expect(config.calendar_entries.size).to eq(3)
      expect(config.calendar_entries[0].name).to eq('Christmas')
      expect(config.calendar_entries[1].name).to eq('Easter')
    end
  end
end

RSpec.describe Config, 'Raises an argument error' do
  context 'Given a JSON parser and a path to an invalid config' do
    it 'will raise a descriptive argument error' do
      config = Config.new JSONParser
      expect { config.load_configuration('./tests/broken_config.json') }
        .to raise_error(
          %r{The file at ./tests/broken_config.json contains invalid JSON}
        )
    end
  end
end
