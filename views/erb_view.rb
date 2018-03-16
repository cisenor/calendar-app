require 'erb'
require_relative '../utility/log'

class PrintToERB
  def initialize(template_path, log = ConsoleLog.new)
    @log = log
    @template = File.read(template_path)
  rescue IOError
    @log.error "Could not find template file at #{template_path}"
  end

  def render(bind, dest)
    raise 'No ERB template is loaded.' unless @template
    populated = ERB.new(@template).run(bind)
    File.open(dest, 'w+', 0o644) { |file| file.puts populated }
  end
end
