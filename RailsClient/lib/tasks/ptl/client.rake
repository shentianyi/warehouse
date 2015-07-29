namespace :ptl do
  desc 'start ptl....'
  task :client => :environment do
    # $led_servers=[]
    # SysConfig.led_servers.split(',').each do |server_info|
    #   puts "listen: #{server_info}"
    #
    #   t= Thread.new do
    #     $led_servers<< Ptl::Message::SendParser.new(server_info)
    #   end
    #   t.join
    #
    #   puts $led_servers
    # end
    # loop {}
  end
end