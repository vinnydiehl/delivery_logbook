require "delivery_logbook/data"
require "delivery_logbook/order"

require "date"
require "nutella"
require "street_address"
require "yaml"

module DeliveryLogbook
  class Logbook
    class << self
      def add(order)
        save orders << order
      end

      def delete(ticket)
        save orders.delete_if { |o| o.ticket == ticket }
      end

      def search(query, method)
        orders.select do |order|
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

      def summarize(orders = orders)
        summary = Hash[%i[tip in_pocket].map do |calculation|
          [calculation, orders.map(&calculation).sum]
        end]

        <<-EOS.heredoc.strip
          Orders:    #{orders.length}
          Tips:      #{summary[:tip].to_currency}
          Avg. Tip:  #{(summary[:tip] / orders.size).to_currency}

          In Pocket: #{summary[:in_pocket].to_currency}
        EOS
      end

      def exists?(ticket)
        orders.any? { |order| order.ticket == ticket }
      end

      private

      # Returns the orders in the data file (or an empty array if there are
      # none)
      def orders
        File.exist?(DATA_FILE) ? YAML.load(File.read DATA_FILE) : []
      end

      # Saves +new_orders+ to a YAML file.
      def save(new_orders)
        File.write DATA_FILE, new_orders.to_yaml
      end
    end
  end
end
