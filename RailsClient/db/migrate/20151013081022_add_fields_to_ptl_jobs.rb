class AddFieldsToPtlJobs < ActiveRecord::Migration
  def change
    add_column :ptl_jobs, :to_state, :integer
    add_column :ptl_jobs, :to_display, :string
    add_column :ptl_jobs, :node_id, :string
  end
end
