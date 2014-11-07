%w[logbook version].each { |r| require "delivery_logbook/#{r}" }

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
        c.option "-d DATE", Date,
                 "Choose the date to add deliveries for (default today)"

        c.action do |args, opts|
          opts.default date: Date.today
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
      end
    end
  end
end
