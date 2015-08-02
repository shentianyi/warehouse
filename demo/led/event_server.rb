require 'eventmachine'

class EchoServer < EM::Connection
  def initialize
    @total = 0
    @total_data = 0
  end

  def post_init
    puts 'new client'
  end

  def receive_data(data)
    @total += 1
    @total_data += data.length
    puts "data: #{data}"
  end
end


EventMachine.run do
  Signal.trap("INT") { EventMachine.stop }
  Signal.trap("TERM") { EventMachine.stop }
  EventMachine.start_server("192.168.0.115", 8899, EchoServer)
end