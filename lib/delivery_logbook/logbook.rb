require "delivery_logbook/data"

require "nutella"
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
      @orders.delete_if { |o| o.ticket = ticket }
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
