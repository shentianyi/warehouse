namespace :ptl do
  desc 'start ptl....'
  task :start => :environment do
    $led_servers=[]
    SysConfig.led_servers.split(',').each do |server_info|
      $led_servers<< Ptl::Message::SendParser.new(server_info)
    end

  end
end