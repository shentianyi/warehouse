class AddOrderStateToPtlJobs < ActiveRecord::Migration
  def change
    add_column :ptl_jobs, :order_state, :integer,default:Ptl::State::PtlOrderState::UN_HANDLE
  end
end
