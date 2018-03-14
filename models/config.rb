##
# Parses a configuration file into a usable class
class Config
  attr_reader :calendar_entries
  def initialize(parser)
    @parser = parser.new
  end

  def load_configuration(path)
    raise IOError, "File at #{path} doesn't exist." unless File.file? path
    str = File.read(path)
    config = @parser.parse(str)
    return unless config_is_valid?(config)
    @calendar_entries = config['calendar-entries'].map do |hash|
      ConfigEntry.new(hash)
    end
  end

  private

  def config_is_valid?(config)
    !config['calendar-entries'].nil?
  end
end

class ConfigEntry
  attr_reader :date
  attr_reader :name
  attr_reader :month
  attr_reader :nth
  attr_reader :weekday
  def initialize(hash)
    @date = hash['date']
    @name = hash['name']
    return unless hash['occurrence']
    @month, @nth, @weekday = hash['occurrence'].to_s.split('/').map(&:to_i)
  end
end
