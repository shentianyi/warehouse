module Extensions
  module UUID
    extend ActiveSupport::Concern
    included do
      #set_primary_key 'id' rails 3
      #self.primary_key='id' # rails 4
      before_create :generate_uuid
      before_update :reset_dirty_flag

      def generate_uuid
        self.id = SecureRandom.uuid if self.id.nil?
        self.uuid= SecureRandom.uuid if self.respond_to?(:uuid) and self.send(:uuid)
      end

      def reset_dirty_flag
        unless self.is_dirty_changed?
          self.is_dirty=true
        end
      end
    end
  end
end