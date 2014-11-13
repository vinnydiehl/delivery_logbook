require "delivery_logbook/data"

require "date"
require "nutella"
require "street_address"
require "yaml"

module DeliveryLogbook
  class Logbook
    def initialize
      @orders = File.exist?(DATA_FILE) ? YAML.load(File.read DATA_FILE) : []
    end

    def add(order)
      @orders << order
      save
    end

    def delete(ticket)
      @orders.delete_if { |o| o.ticket == ticket }
      save
    end

    def search(query, method)
      @orders.select do |order|
        case method
        when :date
          order.date == Date.parse(query)
        when :address
          # TODO: Search entire streets (also looser address search in general)
          order.address == StreetAddress::US.parse(query)
        when :notes
          # TODO: A smarter notes search
          order.notes.downcase.include? query
        when :flags
          # The order should have all of the flags queried for
          (query.chars.map(&:to_sym) - order.flags).empty?
        else
          # Anything else should be an exact match
          order.send(method) == query
        end
      end
    end

    def customer(address)
    end

    private

    # Saves the orders to a YAML file.
    def save
      File.write DATA_FILE, @orders.to_yaml
    end
  end
end
