module Extensions
  module UUID
    extend ActiveSupport::Concern
    include do
      self.primiary_key='id'
      before_create :generate_uuid

      def generate_uuid
        self.id  = SecureRandom.uuid if self.id.nil?
      end
    end
  end
end