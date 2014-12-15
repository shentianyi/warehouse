require_relative 'config.rb'
module Sync
  class BaseSync
    # BASE_URL= "#{$SYNC_HOST}/api/v1/sync/"
    # ACCESS_TOKEN='3dcba17f596969a676bfdd90b5425c703f983acf7306760e1057c95afe9f17b1d'
    #RECORD_PER_REQUEST_SIZE=500

    def self.execute
      ## base data
      current=Time.now
      begin
        Sync::Execute::LocationSync.sync
        Sync::Execute::LocationDestinationSync.sync
        Sync::Execute::LocationContainerSync.sync
        Sync::Execute::HackerSync.sync
        Sync::Execute::WhouseSync.sync
        Sync::Execute::PartTypeSync.sync
        Sync::Execute::PartSync.sync
        Sync::Execute::PositionSync.sync
        Sync::Execute::PartPositionSync.sync
        Sync::Execute::PickItemFilterSync.sync
      rescue => e
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end

      no_error=true
      # sync delivery data
      begin
        Sync::Execute::ContainerSync.sync
        Sync::Execute::LocationContainerSync.sync
        Sync::Execute::RecordSync.sync
      rescue => e
        no_error=false
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end

      begin
        Sync::Execute::StorageSync.sync
      rescue => e
        no_error=false
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end

      begin
        Sync::Execute::RegexCategorySync.sync
        Sync::Execute::RegexSync.sync
      rescue => e
        no_error=false
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end


      begin
        # sync order data
        Sync::Execute::OrderSync.sync
        Sync::Execute::OrderItemSync.sync
      rescue => e
        no_error=false
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end
      begin
        # sync pick list data
        Sync::Execute::PickListSync.sync
        Sync::Execute::PickItemSync.sync
      rescue => e
        no_error=false
        puts "[#{Time.now.localtime}][ERROR]"
        puts e.class
        puts e.to_s
        puts e.backtrace
      end
      Sync::Config.last_time=(current- Sync::Config.advance_second.seconds).utc if no_error
    end

    def self.sync
      if Config.enabled
        if executor=Sync::Executor.find(main_key)
          puts "[#{Time.now.localtime}][INFO]"
          puts "[#{Time.now.localtime}]#{executor.key} start sync..."
          get &get_block if executor.get
          post &post_block if executor.post
          put &put_block if executor.put
          delete &delete_block if executor.delete
          puts "[#{Time.now.localtime}]#{executor.key} finsh sync..."
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
          msg= JSON.parse(response.body)
          if msg['result']
            yield(items, JSON.parse(response)) if block_given?
          else
            puts "[#{Time.now.localtime}][ERROR]#{msg}"
          end
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
        break if items.count==0
        items.collect { |item|
          item.is_dirty=false
          item
        }
        items_hash=items.collect { |item|
          clean_put(item.attributes)
        }
        response=site.put({main_key => items_hash.to_json})
        if response.code==200
          #yield(items, JSON.parse(response)) if block_given?
          msg= JSON.parse(response.body)
          if msg['result']
            yield(items, JSON.parse(response)) if block_given?
          else
            puts "[#{Time.now.localtime}][ERROR]#{msg}"
          end
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
          item
        }
        site= init_site(url+'/delete')
        response=site.post({main_key => items.collect { |i| i.id }.to_json})
        if response.code==201
          #yield(items, JSON.parse(response)) if block_given?
          msg= JSON.parse(response.body)
          if msg['result']
            yield(items, JSON.parse(response)) if block_given?
          else
            puts "[#{Time.now.localtime}][ERROR]#{msg}"
          end
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
          item.save if item.can_reset_sync_dirty_flag
        end
        #model.record_timestamps=true
      end
    end

    def self.put_block
      Proc.new do |items, response|
        model.record_timestamps=false
        items.each do |item|
          item.save if item.can_reset_sync_dirty_flag
        end
        #model.record_timestamps=true
      end
    end

    def self.delete_block
      Proc.new do |items, response|
        model.record_timestamps=false
        items.each do |item|
          item.save
        end
        #model.record_timestamps=true
      end
    end


    private

    def self.url
      "#{Sync::Config.host}/api/v1/sync/#{main_key.pluralize}"
    end

    def self.get_posts(page=0)
      model.unscoped.where(is_new: true).limit(Sync::Config.per_request_size).all
    end

    def self.get_puts(page=0)
      model.unscoped.where(is_dirty: true, is_delete: false).limit(Sync::Config.per_request_size).all
    end

    def self.get_deletes(page=0)
      model.unscoped.where(is_dirty: true, is_delete: true).limit(Sync::Config.per_request_size).all
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
