class OperationLog < ActiveRecord::Base
  self.table_name = "versions"

  default_scope { order(created_at: :desc) }
end
