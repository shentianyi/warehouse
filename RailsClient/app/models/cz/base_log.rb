module CZ
  class BaseLog
=begin
    @@folder=nil
    @@file_name=$LOG_FILE_NAME
    unless File.directory?($LOG_FOLDER)
      #create folder
      system 'mkdir', '-p', "#{$LOG_FOLDER}"
      puts "Log folder #{$LOG_FOLDER} created!" if File.directory?$LOG_FOLDER
    end

    #
    def self.write()

    end
=end
  end
end