require_relative 'base_sync'
module Sync
  class UniqIdSyncBase<BaseSync
    def self.pull_block
      super
      Proc.new do |items|
        items.each do |item|
          unless ori=model.unscoped.where(model.fk_condition(item)).first
            model.new(item)
            model.is_new=false
            model.is_dirty=false
            model.save
          else
            item=model.new(item)
            if ori.is_delete
              attr={is_delete: true, is_dirty: false, is_new: false}.merge(ori.gen_uniq_sync_attr(item))
              ori.update(attr)
            else
              attr={is_dirty: false, is_new: false}.merge(ori.gen_uniq_sync_attr(item))
              ori.update(attr)
            end if ori.updated_at<=item.updated_at
          end
        end
      end
    end
  end
end