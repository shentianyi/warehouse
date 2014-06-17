module Extensions
  module CREATOR
    extend ActiveSupport::Concern
    included do
      after_save :set_creator

      def set_creator
        self.user = current_user
        self.save
      end
    end
  end
end