class AddIndexOnBuildState < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def change
    add_index :builds, :state, algorithm: :concurrently
  end
end
