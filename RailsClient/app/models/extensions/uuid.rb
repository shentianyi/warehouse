module Extensions
  module UUID
    extend ActiveSupport::Concern
    included do
      #set_primary_key 'id' rails 3
      #self.primary_key='id' # rails 4
      default_scope { where(is_delete: false) }
      before_create :generate_uuid
      before_update :reset_dirty_flag

      def generate_uuid
        self.id = self.send(:generate_id) if self.id.nil? && self.respond_to?(:generate_id)
        self.id = SecureRandom.uuid if self.id.nil?
        self.uuid= SecureRandom.uuid if self.respond_to?(:uuid) and self.send(:uuid).nil?
      end

      def reset_dirty_flag
        unless self.is_dirty_changed?
          self.is_dirty=true
        end
      end

      def destroy
        self.is_delete=true
        self.save
      end

      # for sync
      def self.fk_condition(arg)
        c={}
        self::FK.each do |k|
          c[k]=arg[k]
        end
      end

      def gen_sync_attr(item)
        attr={}
        self.attributes.except('uuid','is_delete', 'is_dirty', 'is_new').keys.each do |k|
          attr[k.to_sym]=item.send(k.to_sym)
        end
        return attr
      end

      def gen_uniq_sync_attr(item)
        attr={}
        self.attributes.except('id','is_delete', 'is_dirty', 'is_new').keys.each do |k|
          attr[k.to_sym]=item.send(k.to_sym)
        end
        return attr
      end
    end
  end
end