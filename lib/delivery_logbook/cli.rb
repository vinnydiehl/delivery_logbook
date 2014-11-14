%w[core_ext data flags logbook order version].each do |r|
  require "delivery_logbook/#{r}"
end

require "commander/import"
require "date"
require "nutella"
require "street_address"

module DeliveryLogbook
  class CLI
    def self.start
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
          # Date is an unsupported option type so do it a string
          date = Date.parse(opts.date || Date.today.to_s)

          puts "Adding deliveries for #{date.format}."

          loop do
            # String inputs get #to_s because of a nasty HighLine bug that
            # causes HighLine::String YAML serialization to be irreversible

            ticket = ask("\nTicket (q to quit): ") do |q|
              q.validate = /(q(uit)?|\d{8}#{FLAGS_ANY_REGEX})/i
              q.responses[:not_valid] = <<-EOS.heredoc
                Must be 8 digits followed by any number of the following flags:
                #{FLAGS_LIST}
                Example: 12345678LK
              EOS
            end.to_s

            break if ticket[0] == "q"

            # Ticket number and flags are input at once, break them down into
            # two separate variables
            flags = (ticket[FLAGS_REGEX] || "").downcase.chars.map &:to_sym
            ticket.gsub! FLAGS_REGEX, ""

            address = StreetAddress::US.parse ask("Address: ").to_s

            total = ask("Total: ", Float) { |q| q.above = 0 }
            received = ask("Received: ", Float) { |q| q.above = 0 }

            notes = ask_editor if agree("Notes? ") { |q| q.default = "n" }

            Logbook.add Order.new ticket, address, total,
                                  received, date, notes, flags
          end
        end
      end

      command :delete do |c|
        c.syntax = "dlog delete TICKET"
        c.description = "Delete a delivery."

        c.action do |args|
          Logbook.delete args[0]
        end
      end

      command :search do |c|
        c.syntax = "dlog search QUERY"
        c.description = "Search for a customer or a specific delivery."

        c.action do |args|
          # The menu returns an array with arguments to Logbook#search
          results = Logbook.search *(choose do |menu|
            menu.prompt = "Search method: "

            menu.choices(*%i[Ticket Date Address Notes Flags]) do |choice|
              [
                ask("Enter #{choice}: ") do |q|
                  case choice
                  when :Ticket
                    q.validate = /\d{8}/
                    q.responses[:not_valid] = "Ticket number must be 8 digits."
                  when :Date
                    q.default = "#{Date.today.month}/#{Date.today.day}"
                  when :Flags
                    q.validate = /^#{FLAGS_REGEX}$/
                    q.responses[:not_valid] = <<-EOS.heredoc
                      Choose any number of the following:
                      #{FLAGS_LIST}
                    EOS
                  end
                end,
                choice
              ]
            end
          # Query and method should both be lowercase so that the search can be
          # case-insensitive and method can be passed to #send
          end.map &:downcase)

          puts "\nNo results." if results.empty?

          results.each { |r| puts "\n#{"-" * TERM_WIDTH}\n\n#{r}" }
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
