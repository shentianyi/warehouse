require_relative 'config.rb'
module Sync
  class BaseSync
    BASE_URL= 'http://localhost:3000/api/v1/sync/'
    ACCESS_TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'

    def self.sync
      puts '--------'
      if Config.enabled
        #begin
        #pull &pull_block
        #post &post_block
        #put &put_block
        #delete &delete_block
        #rescue => e
        #  puts e.class
        #  puts e.to_s
        #end
      end
    end

    # sync pull
    def self.pull
      current=Time.now
      site=init_site(URI::encode(self::PULL_URL+'?last_time='+Sync::Config.last_time.to_s))
      #Config.last_time=(current- Config.advance_second.seconds)

      response=site.get
      if response.code==200
        yield(JSON.parse(response)) if block_given?
      end
    end

    # sync post
    def self.post
      site=init_site(self::POST_URL)
      get_posts.each do |item|
        item.is_new=false
        item.is_dirty=false
        response= site.post({main_key => item.to_json})
        if response.code==201
          yield(item, JSON.parse(response)) if block_given?
        end
      end
    end

    # sync update
    def self.put
      get_puts.each do |item|
        item.is_dirty=false
        site=init_site(self::POST_URL+'/'+item.id)
        response=site.put({main_key => clean_put(item.attributes)})
        if response.code==200
          yield(item, JSON.parse(response)) if block_given?
        end
      end
    end

    # sync delete
    def self.delete
      get_deletes.each do |item|
        item.is_dirty=false
        site= init_site(self::POST_URL+'/'+item.id)
        response=site.delete
        if response.code==200
          yield(item, JSON.parse(response)) if block_given?
        end
      end
    end

    # blocks

    def self.post_block
      Proc.new do |item, response|
        model.record_timestamps=false
        item.save
      end
    end

    def self.put_block
      Proc.new do |item, response|
        model.record_timestamps=false
        item.save
      end
    end

    def self.delete_block
      Proc.new do |item, response|
        model.record_timestamps=false
        item.save
      end
    end


    private

    def self.get_posts
      model.where(is_new: true).all
    end

    def self.get_puts
      model.where(is_dirty: true, is_new: false, is_delete: false).all
    end

    def self.clean_put item
      item.except('uuid', 'id', 'created_at')
    end

    def self.get_deletes
      model.where(is_dirty: true, is_delete: true).all
    end

    def self.main_key
      model_name.downcase
    end

    def self.model
      model_name.constantize
    end

    def self.init_site(url)
      RestClient::Resource.new(url, headers: {'Authorization' => "Bearer #{ACCESS_TOKEN}"}, 'content_type' => 'application/json')
    end

    def self.model_name
      self.name.gsub(/Sync|::/, '')
    end
  end
end