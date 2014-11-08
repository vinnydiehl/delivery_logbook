%w[flags logbook order version].each { |r| require "delivery_logbook/#{r}" }

require "commander/import"
require "date"
require "nutella"

module DeliveryLogbook
  class CLI
    def self.start
      log = Logbook.new

      {
        name: "Delivery Logbook",
        version: VERSION,
        description: Gem::Specification::find_by_name("delivery_logbook").description
      }.each { |attr, value| program attr, value }

      default_command :add

      command :add do |c|
        c.syntax = "dlog add [options]"
        c.description = "Add deliveries."
        c.option "--date DATE", String,
                 "Choose the date to add deliveries for (default today)"

        c.action do |args, opts|
          # Date is an unsupported option type so do it with strings
          date = Date.parse opts.date || Date.today.to_s

          loop do
            # String inputs get #to_s because of a nasty HighLine bug that
            # causes HighLine::String YAML serialization to be irreversible

            ticket = ask("Ticket (q to quit): ") do |q|
              q.validate = /(q(uit)?|\d{8}#{FLAGS_ANY_REGEX})/i
            end.to_s

            break if ticket[0] == "q"

            # Ticket number and flags are input at once, break them down into
            # two separate variables
            flags = (ticket[FLAGS_REGEX] || "").downcase.chars.map &:to_sym
            ticket.gsub! FLAGS_REGEX, ""

            total = ask("Total: ", Float) { |q| q.above = 0 }
            received = ask("Received: ", Float) { |q| q.above = 0 }

            notes = ask("Notes: ").to_s

            order = Order.new ticket, total, received, date, notes, flags

            puts

            log.add order
          end
        end
      end

      command :delete do |c|
        c.syntax = "dlog delete TICKET"
        c.description = "Delete a delivery."

        c.action do |args|
        end
      end

      command :search do |c|
        c.syntax = "dlog search QUERY"
        c.description = "Search for a customer or a specific delivery."

        c.action do |args|
        end
      end

      command :stats do |c|
        c.syntax = "dlog stats"
        c.description = "Displays statistics calculated from your logbook."

        c.action do
        end
      end
    end
  end
end
