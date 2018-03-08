# Any interfacing with the terminal
class Console
  def clear
    system 'clear' or system 'cls'
  end

  def prompt_for_input(prompt)
    prompt += ' ' unless prompt.end_with? ' '
    print prompt
    gets.chomp
  end

  def prompt_for_action(prompt)
    prompt += ' ' unless prompt.end_with? ' '
    print prompt
    value = gets.chomp.upcase[0]
    puts value
    case value
    when 'Y'
      return :display_year
    when 'C'
      return :change_year
    when 'H'
      return :display_holidays
    when 'A'
      return :add_holiday
    when 'X'
      return :exit
    else
      return :nothing
    end
  end
end
