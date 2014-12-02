module CZ
  module Recordable
    def get_records
      self.records.order(impl_time: :asc)
    end
  end
end