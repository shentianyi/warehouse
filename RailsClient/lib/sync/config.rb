
module Sync
  class Config
    @@config=nil
    CONFIG_PATH= "#{Rails.root}/config/sync.yml"

    def self.method_missing(method, *args, &block)
      if method.to_s=~/=$/
        set(method.to_s.sub(/=/, ''), args[0])
      else
        get method.to_s
      end
    end

    def self.get key
      config[key]
    end

    def self.set key, value
      config[key]=value
      File.open(CONFIG_PATH, 'w') do |f|
        f.write(@@config.to_yaml)
      end
    end

    def self.config
      unless @@config
        @@config= YAML::load(File.open("#{Rails.root}/config/sync.yml"))
      end
      @@config['sync']
    end
  end
end