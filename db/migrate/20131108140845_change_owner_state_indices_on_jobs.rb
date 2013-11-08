class ChangeOwnerStateIndicesOnJobs < ActiveRecord::Migration
  self.disable_ddl_transaction!

  def up
    execute "CREATE INDEX CONCURRENTLY index_jobs_on_owner_id_and_owner_type ON jobs (owner_id, owner_type);"
    execute "CREATE INDEX CONCURRENTLY index_jobs_on_state ON jobs (state);"
    execute "DROP INDEX index_jobs_on_owner_id_and_owner_type_and_state;"
    execute "DROP INDEX index_jobs_on_state_owner_type_owner_id;"
  end

  def down
    execute "CREATE INDEX CONCURRENTLY index_jobs_on_owner_id_and_owner_type_and_state ON jobs (owner_id, owner_type, state);"
    execute "CREATE INDEX CONCURRENTLY index_jobs_on_state_owner_type_owner_id ON jobs (state, owner_type, owner_id);"
    execute "DROP INDEX index_jobs_on_owner_id_and_owner_type;"
    execute "DROP INDEX index_jobs_on_state;"
  end
end
