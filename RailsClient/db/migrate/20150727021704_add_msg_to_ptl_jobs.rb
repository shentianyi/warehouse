class AddMsgToPtlJobs < ActiveRecord::Migration
  def change
    add_column :ptl_jobs, :msg, :text
  end
end
