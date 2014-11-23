module Sync
  class Config
    @@config=nil
    @@executors=nil
    @@last_sync_time=nil
    CONFIG_PATH= "#{Rails.root}/config/sync.yml"
    TIME_TMP_FILE="#{Rails.root}/tmp/config/sync_last_time.md"

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
    end

    def self.save
      File.open(CONFIG_PATH, 'w') do |f|
        f.write(@@config.to_yaml)
      end
    end

    def self.last_time
      unless File.exists?(TIME_TMP_FILE)
        FileUtils.mkdir_p(File.dirname(TIME_TMP_FILE))
        File.open(TIME_TMP_FILE, 'wb') do |f|
          f.write(Time.now-5.days)
        end
      end
      unless @@last_sync_time
        File.open(TIME_TMP_FILE, 'r') do |f|
          @@last_sync_time=Time.parse(f.readline)
        end
      end
      @@last_sync_time
    end

    def self.last_time=(value)
      @@last_sync_time=value
      File.open(TIME_TMP_FILE, 'w') do |f|
        f.write(value)
      end
    end

    def self.config
      unless @@config
        @@config= YAML::load(File.open("#{Rails.root}/config/sync.yml"))
      end
      @@config['sync']
    end

    def self.executors
      unless @@executors
        @@executors={}
        self.executor.each do |k, v|
          @@executors[k]=Executor.new(key: k, name: v['name'], get: v['get'], post: v['post'], put: v['put'], delete: v['delete'])
        end
      end
      @@executors
    end

    def self.executor=(executor)
      %w(get post put delete).each do |m|
        config['executor'][executor.key][m]=executor.send(m)
      end
    end

    def self.skip_muti_callbacks models
      models.each do |model|
        skip_callbacks(model)
      end
    end

    def self.skip_callbacks model
      model.record_timestamps=false
      model.skip_callback(:update, :before, :reset_dirty_flag)
      model.skip_callback(:create,:before,:init_container_attr)
    end

    def self.reload
      @@config=nil
    end
  end
end