class AddIndexToJobsOnOwnerIdOwnerTypeAndState < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def change
    add_index :jobs, [:owner_id, :owner_type, :state], algorithm: :concurrently
  end
end
