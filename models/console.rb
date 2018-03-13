# Any interfacing with the terminal
class Console
  def clear
    system 'clear' or system 'cls'
  end

  def prompt_for_input(prompt)
    prompt << ' ' unless prompt.end_with? ' '
    print prompt
    gets.chomp
  end

  def prompt_for_action
    puts ''
    print 'Commands: Show full year (Y), Change year (C), View holidays (H), Add holiday (A), Exit (X): '
    value = gets.chomp.upcase[0]
    option(value.to_sym)
  end

  private

  def option(key)
    options = { Y: :display_year, C: :change_year, H: :display_holidays, A: :add_holiday, X: :exit }
    options.fetch(key, :nothing)
  end
end
