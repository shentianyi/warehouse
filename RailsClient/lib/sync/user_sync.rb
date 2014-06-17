module Sync
  class UserSync< BaseSync
    PULL_URL= BASE_URL+'users'
    POST_URL= BASE_URL+'users'

    def self.pull_block
      User.record_timestamps=false
      User.skip_callback(:update,:before,:reset_dirty_flag)
      #User.observers.disable :all
      Proc.new do |items|
        items.each do |item|
          item=User.new(item)
          puts item.updated_at
          puts User.find_by_id(item.id).updated_at
          unless user=User.find_by_id(item.id)
            User.create(item)
          else
            if user.is_delete
              user.update(is_delete: true, is_dirty: false, is_new: false, updated_at: item.updated_at, name: item.name)
            else
              user.update(is_dirty: false, is_new: false, updated_at: item.updated_at, name: item.name)
            end if user.updated_at<=item.updated_at
          end
        end
      end
    end

    def self.post_block
      Proc.new do |item, response|
        User.record_timestamps=false
        item.save
      end
    end

    def self.put_block
      Proc.new do |item, response|
        User.record_timestamps=false
        item.save
      end
    end

    def self.delete_block
      Proc.new do |item, response|
        User.record_timestamps=false
        item.save
      end
    end
  end
end
