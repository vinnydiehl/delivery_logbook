%w[core_ext flags].each { |r| require "delivery_logbook/#{r}" }

require "nutella"

module DeliveryLogbook
  class Order
    attr_reader *%i[ticket address date notes flags tip in_pocket]

    initializer *%i[ticket address total received date notes flags] do
      @tip = @received - @total
      @in_pocket = @tip + 1

      @flags << :s if stiff?
      @flags << :t if good?

      @flags &= FLAGS.keys
    end

    def stiff?
      @tip < 1
    end

    def good?
      @tip >= 5
    end

    def notes?
      # #to_s for a nil check
      !notes.to_s.empty?
    end

    def to_s
      <<-EOS.heredoc.strip
        Ticket ##{@ticket}#{" [Notes]" if notes?}
        Date: #{@date.format}#{"

        Flags: #{flags.map { |f| FLAGS[f] }.join " | "}" unless flags.empty?}

        Address: #{@address}

        Total:     #{@total.to_currency}
        Received:  #{@received.to_currency}
        Tip:       #{@tip.to_currency}
        In Pocket: #{@in_pocket.to_currency}
      EOS
    end
  end
end
