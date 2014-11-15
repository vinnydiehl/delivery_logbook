require "highline"

module DeliveryLogbook
  # The location of the file where the logbook is stored.
  DATA_FILE = "#{Dir.home}/.dlog"

  # Line the width of the user's terminal in '-' characters
  LINE = "-" * HighLine::SystemExtensions.terminal_size[0]
end
