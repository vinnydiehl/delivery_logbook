require "highline"

module DeliveryLogbook
  # The location of the file where the logbook is stored.
  DATA_FILE = "#{Dir.home}/.dlog"

  # User's terminal width
  TERM_WIDTH = HighLine::SystemExtensions.terminal_size[0]
end
