##
# Displays the provided calendar object based on a provided formatter
class Display
  def initialize(formatter, printer)
    @formatter = formatter
    @printer = printer
  end

  def print_calendar(year, calendar_entry_store)
    @calendar_entry_store = calendar_entry_store
    raise ArgumentError 'Year must be a Year object.' if year.class != Year
    @printer.start_output
    write @markup.get_markup_block(year.year, 'centered header')
    write @markup.get_markup_block(create_months(year.months), 'container')
    write get_calendar_entries
    @printer.end_output
  end

  private

  def start_output
    @printer.start_output
  end

  def end_output
    @printer.end_output
  end
end
