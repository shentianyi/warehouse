require_relative 'base_sync'
module Sync
  class UniqIdSyncBase<BaseSync
    # sync delete
    #def self.delete
    #  items=get_deletes.collect { |item|
    #    item.is_dirty=false
    #    item
    #  }
    #  site= init_site(url+'/delete')
    #  response=site.post({main_key => items.to_json})
    #  if response.code==201
    #    yield(items, JSON.parse(response)) if block_given?
    #  end
    #end
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
        response=site.post({main_key => items.to_json})
        if response.code==201
          yield(items, JSON.parse(response)) if block_given?
        end
        i+=1
      end
    end

    def self.get_block
      super
      Proc.new do |items|
        items.each do |item|
          unless ori=model.unscoped.where(model.fk_condition(item)).first
            ori=model.new(item)
            ori.is_new=false
            ori.is_dirty=false
            ori.save
          else
            item=model.new(item)
            if ori.is_delete
              attr={is_dirty: false, is_new: false}.merge(ori.gen_uniq_sync_attr(item))
              ori.update(attr)
            else
              attr={is_dirty: false, is_new: false}.merge(ori.gen_uniq_sync_attr(item))
              ori.update(attr)
            end if ori.updated_at<item.updated_at
          end
        end
      end
    end
  end
end