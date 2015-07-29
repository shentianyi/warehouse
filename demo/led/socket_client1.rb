require "socket"
class Client
  def initialize(server)
    @server = server
    @request = nil
    @response = nil
    listen
    send
    @request.join
    @response.join
  end

  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets
        puts "from server:#{msg}"
      }
    end
  end

  def send
    puts "Enter the username:"
    @request = Thread.new do
      loop {
        msg = $stdin.gets.chomp
        @server.puts(msg)
      }
    end
  end
end

server = TCPSocket.open('192.168.0.115', 8899)
Client.new(server)
