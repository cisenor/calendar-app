require 'erb'
require_relative '../utility/log'

class PrintToERB
  def initialize(template_path, log = ConsoleLog.new)
    @log = log
    @template = File.read(template_path)
  rescue IOError
    @log.error "Could not find template file at #{template_path}"
  end

  def render(bind)
    raise 'No ERB template is loaded.' unless @template
    ERB.new(@template).run(bind)
  end
end
