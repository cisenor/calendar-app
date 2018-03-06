require_relative './year.rb'

# Renders the supplied year class
class Renderer
  def render_year(year)
    return false if year.class != Year
    puts year.year
  end
end
