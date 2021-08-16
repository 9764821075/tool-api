class AddTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :token, :string
    add_column :users, :token_valid_until, :datetime

    add_index :users, :token, unique: true
  end
end
