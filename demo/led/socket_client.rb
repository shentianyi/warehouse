require "socket"
class Client
  def initialize( server )
    @server = server
    @request = nil
    @response = nil
    listen
    # send
    # @request.join
    # @response.join
  end

  def listen
    @response = Thread.new do
      loop {
        msg = @server.gets.chomp
        puts "#{msg}"
      }
    end
  end

  def send(msg)
    puts "Enter the username:"
    @request = Thread.new do
      # loop {
      #   msg = $stdin.gets.chomp
        @server.puts( msg )
      # }
    end
  end
end

server = TCPSocket.open( "localhost", 9000 )
c=Client.new( server )

c.send(';2343')