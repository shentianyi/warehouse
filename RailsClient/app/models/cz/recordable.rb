module CZ
  module Recordable
    def get_records
      self.records.order(impl_user_type: :asc)
    end
  end
end