# require 'ptl'
require 'socket'

if SysConfig.led_enable=='true'
#   require 'ptl'
#
#   $led_servers=[]
#   SysConfig.led_servers.split(',').each do |server_info|
#     $led_servers<< Ptl::Message::SendParser.new(server_info)
#   end

  $led_socket=nil
  $led_socket_clients={}

  # if defined?(PhusionPassenger)
  #   PhusionPassenger.on_event(:starting_worker_process) do |forked|
  #     if forked
  #       if !$led_socket.nil? && !$led_socket.closed?
  #         $led_socket_clients={}
  #         $led_socket.close
  #       end
  #       $led_socket=TCPServer.new('192.168.0.115', 8899)
  #     end
  #   end
  # end
end

