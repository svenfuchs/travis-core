class AddForeignKeysOnPermissions < ActiveRecord::Migration
  def up
    add_foreign_key(:permissions, :users, dependent: :delete)
    add_foreign_key(:permissions, :repositories, dependent: :delete)

    execute "ALTER TABLE permissions ALTER COLUMN user_id SET NOT NULL"
    execute "ALTER TABLE permissions ALTER COLUMN repository_id SET NOT NULL"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
