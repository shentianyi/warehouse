namespace :ptl do
  desc 'start ptl server....'
  task :server => :environment do
    pid_file = 'tmp/pids/ptl.pid'
    begin
      pid=File.read(pid_file).to_i
      puts "kill pid #{pid}"
      Process.kill(15, pid)
    rescue => e
      puts e.message
    end
    File.delete pid_file if File.exists? pid_file
    File.open(pid_file, 'w') { |f| f.puts Process.pid }
    Ptl::Server.run
  end
end