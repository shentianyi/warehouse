class RemoveSumAcceptedPackagesFromForklifts < ActiveRecord::Migration
  def change
    remove_column :forklifts, :sum_packages
    remove_column :forklifts, :accepted_packages
  end
end
