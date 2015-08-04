namespace :ptl do
  desc 'stop ptl server....'
  task :stop => :environment do
    pid_file = 'tmp/pids/ptl.pid'
    begin
      pid=File.read(pid_file).to_i
      if pid>0
      puts "kill pid #{pid}"
      Process.kill(15, pid)
      end
    rescue => e
      puts e.message
    end
  end
end