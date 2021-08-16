class RemoveUnusedUserColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :invite_token
    remove_column :users, :invited_at

    remove_index :users, :token
    remove_column :users, :token
    remove_column :users, :token_valid_until
  end
end
