require_relative 'base_sync'
module Sync

  class CustomIdSyncBase<BaseSync
    def self.pull_block
      model.record_timestamps=false
      model.skip_callback(:update, :before, :reset_dirty_flag)
      Proc.new do |items|
        items.each do |item|
          puts item.updated_at
          unless ori=model.find_by_id(item.id)
            model.create(item)
          else
            if ori.is_delete
              attr={is_delete: true, is_dirty: false, is_new: false}.merge(ori.gen_sync_attr(item))
              ori.update(attr)
            else
              attr={is_dirty: false, is_new: false}.merge(ori.gen_sync_attr(item))
              ori.update(attr)
            end if ori.updated_at<=item.updated_at
          end
        end
      end
    end
  end
end