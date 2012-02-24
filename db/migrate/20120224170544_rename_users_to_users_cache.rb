class RenameUsersToUsersCache < ActiveRecord::Migration
  def change
    rename_table :users, :users_caches
  end
end
