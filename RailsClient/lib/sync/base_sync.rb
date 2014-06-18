require_relative 'config.rb'
module Sync
  class BaseSync
    BASE_URL= "#{$SYNC_HOST}/api/v1/sync/"
    ACCESS_TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'

    def self.sync
      if Config.enabled

        #begin
        pull &pull_block
        post &post_block
        put &put_block
        delete &delete_block
        #rescue => e
        #  puts e.class
        #  puts e.to_s
        #end
      end
    end



    # sync pull
    def self.pull
      site=init_site(URI::encode(self::PULL_URL+'?last_time='+Sync::Config.last_time.to_s))
      response=site.get
      if response.code==200
        yield(JSON.parse(response)) if block_given?
      end
    end

    # sync post
    def self.post
      site=init_site(self::POST_URL)
      items=get_posts.collect { |item|
        item.is_new=false
        item.is_dirty=false
        item
      }
      response= site.post({main_key => items.to_json})
      if response.code==201
        yield(items, JSON.parse(response)) if block_given?
      end
    end

    # sync update
    def self.put
      site=init_site(self::POST_URL+'/0')
      items=get_puts.collect { |item|
        item.is_dirty=false
        item
      }
      items_hash=items.collect { |item|
        clean_put(item.attributes)
      }
      response=site.put({main_key => items_hash.to_json})
      if response.code==200
        yield(items, JSON.parse(response)) if block_given?
      end
    end

    # sync delete
    def self.delete
      items=get_deletes.collect { |item|
        item.is_dirty=false
        item
      }
      site= init_site(self::POST_URL+'/delete')
      response=site.post({main_key => items.collect { |i| i.id }.to_json})
      if response.code==201
        yield(items, JSON.parse(response)) if block_given?
      end
    end

    # blocks
    def self.pull_block
      model.record_timestamps=false
      model.skip_callback(:update, :before, :reset_dirty_flag)
      model.skip_callback(:save, :after, :log_state)
      model.skip_callback(:update, :after, :set_update_flag)
    end

    def self.post_block
      Proc.new do |items, response|
        model.record_timestamps=false
        items.each do |item|
          item.save
        end
      end
    end

    def self.put_block
      Proc.new do |items, response|
        model.record_timestamps=false
        items.each do |item|
          item.save
        end
      end
    end

    def self.delete_block
      Proc.new do |items, response|
        model.record_timestamps=false
        items.each do |item|
          item.save
        end
      end
    end


    private

    def self.get_posts
      model.unscoped.where(is_new: true).all
    end

    def self.get_puts
      model.unscoped.where(is_dirty: true, is_new: false, is_delete: false).all
    end

    def self.get_deletes
      model.unscoped.where(is_dirty: true, is_delete: true).all
    end

    def self.clean_put item
      item.except('uuid', 'created_at')
    end

    def self.main_key
      model_name.underscore
    end

    def self.model
      model_name.constantize
    end

    def self.init_site(url)
      RestClient::Resource.new(url, headers: {'Authorization' => "Bearer #{ACCESS_TOKEN}"}, 'content_type' => 'application/json')
    end

    def self.model_name
      self.name.gsub(/Sync|::Execute::/, '')
    end

  end
end
