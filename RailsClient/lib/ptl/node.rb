module Ptl
  class Node

    attr_accessor :state, :color, :rate, :display, :id, :job,:job_id


    NORMAL=100 #正常
    ORDERED=200 #要货
    URGENT_ORDERED=300 #紧急要货
    PICKED=400 #择货
    DELIVERED=500 #发运
    RECEIVED=600 #接受

    @@state_map={
        :'100' => {state: NORMAL, color: 'G', rate: 0},
        :'200' => {state: ORDERED, color: 'R', rate: 0},
        :'300' => {state: URGENT_ORDERED, color: 'R', rate: 3},
        :'400' => {state: PICKED, color: 'B', rate: 0},
        :'500' => {state: DELIVERED, color: 'B', rate: 3},
        :'600' => {state: RECEIVED, color: 'G', rate: 3}
    }

    def initialize(state)
      map=Node.find_map(state)
      self.state=map[:state]
      self.color=map[:color]
      self.rate=map[:rate]
    end


    def self.where(args={})
      @@state_map.values.each do |v|
        puts v

        found=true

        args.each do |k, vv|
          puts "#{k}====#{vv}----#{v[k]}"
          if v[k]!=vv
            (found=false)
            break
          end
        end
        puts "----------#{v}"
        return self.find(v[:state]) if found

      end
    end

    def self.find_map(state)
      @@state_map[state.to_s.to_sym] || raise('No State Error')
    end

    def self.find(state)
      Node.new(state)
    end


    def set_display(urgent_size=0, order_size=0)
      urgent_size=0 if urgent_size<0
      order_size=0 if order_size<0
      # 当要货量为0时，灯变为正常状态
      if order_size==0
        map=Node.find_map(NORMAL)
        self.state=map[:state]
        self.color=map[:color]
        self.rate=map[:rate]
      end
      self.display= "#{'%02d' % urgent_size}#{'%02d' % order_size}"
    end

    def self.parse_display(display)
      return display[0, 1].to_i, display[1, 2].to_i
    end

    def id_format
       self.id+' '*(40-self.id.length)
    end

    def color_format
      self.color
    end

    def rate_format
      '%04d' % self.rate
    end

  end
end
