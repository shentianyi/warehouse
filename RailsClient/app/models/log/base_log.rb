module Log
  class BaseLog

    @@folder=nil
    if File.directory?($LOG_FOLDER)
      puts "Log Folder exosts"
    else
      puts "Log Folder not exists"
    end

    #
    def self.write()

    end
  end
end