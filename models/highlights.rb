class Highlights
  def initialize
    raise 'Not Implemented'
  end

  def highlight(value, key)
    output = @highlights.fetch(key, :none)
    return value unless output
    format output, value: value
  end
end

# Handles date highlighting
class ConsoleTextHighlights < Highlights
  def initialize
    @highlights = {
      holiday: "\e[1m%<value>s\e[0m",
      leap: "\e[1;32;47m%<value>s\e[0m",
      friday13: "\e[41m%<value>s\e[0m",
      none: '%<value>s'
    }
  end
end

# HTML highlighter
class HTMLTextHighlights < Highlights
  def initialize
    @highlights = {
      holiday: '<span class="bold">%<value>s</span>',
      leap: '<span class="leap-day">%<value>s</span>',
      friday13: '<span class="friday-13">%<value>s</span>',
      none: '<span>%<value>s</span>'
    }
  end
end
