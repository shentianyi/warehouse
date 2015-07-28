# require 'ptl'
# if SysConfig.led_enable=='true'
#   require 'ptl'
#
#   $led_servers=[]
#   SysConfig.led_servers.split(',').each do |server_info|
#     $led_servers<< Ptl::Message::SendParser.new(server_info)
#   end
#
#   if defined?(PhusionPassenger)
#     PhusionPassenger.on_event(:starting_worker_process) do |forked|
#       if forked
#         $led_servers.each { |server| server.close }
#         $led_servers=[]
#         SysConfig.led_servers.split(',').each do |server_info|
#           $led_servers<< Ptl::Message::SendParser.new(server_info)
#         end
#       end
#     end
#   end
# end
