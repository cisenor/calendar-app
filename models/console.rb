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
end
