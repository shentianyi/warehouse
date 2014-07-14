require 'base_class'
module Csv
  class CsvConfig<CZ::BaseClass
    attr_accessor :encoding, :col_sep, :file_path

    def self.get_os_name user_agent
      user_agent=user_agent.downcase
      [/windows/, /linux/].each do |o|
        if os=o.match(user_agent)
          return os[0]
        end
      end
    end

    def self.csv_write_encode user_agent
      os= get_os_name(user_agent)
      case os
        when 'windows'
          return 'GB18030'
        when 'linux'
          return 'UTF-8'
        else
          return nil
      end
    end
  end
end
