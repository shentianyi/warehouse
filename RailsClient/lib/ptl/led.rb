module Ptl
  class Led

    attr_accessor :state, :color, :rate


    NORMAL=100
    ORDERED=200
    URGENT_ORDERED=300
    PICKED=400
    DELIVERED=500
    RECEIVED=600

    def initialize(state, color=Led.color(state), rate=Led.rate(state))
      self.state=state
      self.color=color
      self.rate=rate
    end

    def self.color(state)
      case state
        when NORMAL
          'G'
        when ORDERED
          'R'
        when URGENT_ORDERED
          'R'
        when PICKED
          'B'
        when DELIVERED
          'B'
        when RECEIVED
          'G'
        else
          'G'
      end
    end

    def self.rate(state)
      case state
        when NORMAL
          0
        when ORDERED
          0
        when URGENT_ORDERED
          200
        when PICKED
          0
        when DELIVERED
          200
        when RECEIVED
          0
        else
          0
      end
    end


  end
end