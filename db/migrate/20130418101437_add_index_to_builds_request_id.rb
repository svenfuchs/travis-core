class AddIndexToBuildsRequestId < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def change
    add_index :builds, :request_id, algorithm: :concurrently
  end
end
