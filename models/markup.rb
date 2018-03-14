# Handles date highlighting
class ConsoleMarkup
  def initialize
    @highlights = {
      holiday: "\e[1m%<value>s\e[0m",
      leap: "\e[1;32;47m%<value>s\e[0m",
      friday13: "\e[41m%<value>s\e[0m",
      none: '%<value>s'
    }
  end

  ##
  # @return a style symbol to be used by the view for stylized rendering.
  def highlight(value, key)
    output = @highlights.fetch(key, :none)
    return value unless output
    format output, value: value
  end

  def get_markup_block(content, _class = nil)
    content + "\n"
  end

  def get_markup_inline(content, _class = nil)
    content
  end

  def get_markup_list(array, _class = nil)
    array.map { |item| item.to_s + "\n" }.join
  end

  def start
    ''
  end

  def end
    ''
  end
end

# HTML highlighter
class HTMLMarkup < ConsoleMarkup
  def initialize
    @highlights = {
      holiday: '<span class="bold">%<value>s</span>',
      leap: '<span class="leap-day">%<value>s</span>',
      friday13: '<span class="friday-13">%<value>s</span>',
      none: '<span>%<value>s</span>'
    }
  end

  def get_markup_block(content, type = nil)
    css_class = " class=\"#{type}\"" if type
    format "<div#{css_class}>#{content}</div>"
  end

  def get_markup_inline(content, type = nil)
    css_class = " class=\"#{type}\"" if type
    "<span#{css_class}>#{content}</span>"
  end

  def get_markup_list(array)
    li = array.map { |item| "<li>#{item}</li>" }.join
    "<ul>#{li}</ul>"
  end

  def start
    '<html><head><link rel="stylesheet" type="text/css" href="styles.css"></head><body>'
  end

  def end
    '</body></html>'
  end
end
