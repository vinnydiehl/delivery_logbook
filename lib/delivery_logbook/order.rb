require "delivery_logbook/flags"

require "nutella"

module DeliveryLogbook
  class Order
    attr_reader :ticket

    initializer *%i[ticket total received date notes flags] do
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

    def to_s
      <<-EOS.heredoc.strip
      Ticket ##{@ticket}
      Date: #{@date}

      Received: $#{@received} / $#{@total}
      Tip: $#{@tip}
      In Pocket: $#{@in_pocket}
      EOS
    end
  end
end
