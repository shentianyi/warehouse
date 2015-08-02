class CreatePtlJobs < ActiveRecord::Migration
  def change

    create_table(:ptl_jobs, :id => false) do |t|
      t.string :id, :limit => 36, :primary => true, :null => false
      t.text :params
      t.integer :state, default: Ptl::State::Job::UN_HANDLE
      #
      t.boolean :is_delete, :default => false
      t.boolean :is_dirty, :default => true
      t.boolean :is_new, :default => true
      #
      t.timestamps
    end
    execute 'ALTER TABLE ptl_jobs ADD PRIMARY KEY (id)'

  end
end
