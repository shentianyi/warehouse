require_relative 'config.rb'
module Sync
  class BaseSync
    # BASE_URL= "#{$SYNC_HOST}/api/v1/sync/"
    # ACCESS_TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'
    RECORD_PER_REQUEST_SIZE=500

    def self.execute
      ## base data
      current=Time.now
      Sync::Execute::LocationSync.sync
      Sync::Execute::HackerSync.sync
      Sync::Execute::WhouseSync.sync
      Sync::Execute::PartSync.sync
      Sync::Execute::PositionSync.sync
      Sync::Execute::PartPositionSync.sync

      # dynamic data
      Sync::Execute::DeliverySync.sync
      Sync::Execute::ForkliftSync.sync
      Sync::Execute::PackageSync.sync
      Sync::Execute::PackagePositionSync.sync
      Sync::Execute::StateLogSync.sync


      Sync::Config.last_time=(current- Sync::Config.advance_second.seconds)
    end

    def self.sync
      if Config.enabled
        begin
        if executor=Sync::Executor.find(main_key)
          puts '*******'
          get &get_block if executor.get
          post &post_block if executor.post
          put &put_block if executor.put
          delete &delete_block if executor.delete
        end
        rescue => e
          puts e.class
          puts e.to_s
        end
      end
    end


    # sync pull
    def self.get
      site=init_site(URI::encode(url+'?last_time='+Sync::Config.last_time.to_s))
      response=site.get
      if response.code==200
        yield(JSON.parse(response)) if block_given?
      end
    end

    # sync post
    def self.post
      site=init_site(url)
      i=0
      while true
        items=get_posts(i)
        break if items.count==0
        items.collect { |item|
          item.is_new=false
          item.is_dirty=false
          item
        }
        response= site.post({main_key => items.to_json})
        if response.code==201
          yield(items, JSON.parse(response)) if block_given?
        end
        i+=1
      end
    end

    # sync update
    def self.put
      site=init_site(url+'/0')
      i=0
      while true
        items=get_puts(i)
        break if item.count==0
        items.collect { |item|
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
        i+=1
      end
    end

    # sync delete
    def self.delete
      i=0
      while true
        items=get_deletes(i)
        break if items.count==0
        items.collect { |item|
          item.is_dirty=false
          item.is_new=false
          item
        }
        site= init_site(url+'/delete')
        response=site.post({main_key => items.collect { |i| i.id }.to_json})
        if response.code==201
          yield(items, JSON.parse(response)) if block_given?
        end
        i+=1
      end
    end

    # blocks
    def self.get_block
      m=model
      Config.skip_callbacks(m)
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

    def self.url
      "#{Sync::Config.host}/api/v1/sync/#{main_key.pluralize}"
    end

    def self.get_posts(page=0)
      model.unscoped.where(is_new: true).offset(page*RECORD_PER_REQUEST_SIZE).limit(RECORD_PER_REQUEST_SIZE).all
    end

    def self.get_puts(page=0)
      model.unscoped.where(is_dirty: true, is_new: false, is_delete: false).offset(page*RECORD_PER_REQUEST_SIZE).limit(RECORD_PER_REQUEST_SIZE).all
    end

    def self.get_deletes(page=0)
      model.unscoped.where(is_dirty: true, is_delete: true).offset(page*RECORD_PER_REQUEST_SIZE).limit(RECORD_PER_REQUEST_SIZE).all
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
      RestClient::Resource.new(url, :timeout => -1,
                               :open_timeout => -1,
                               headers: {'Authorization' => "Bearer #{Sync::Config.token}"}, 'content_type' => 'application/json')
    end

    def self.model_name
      self.name.gsub(/Sync|::Execute::/, '')
    end

  end
end
