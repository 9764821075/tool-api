class RemovePrimaryFromPhoto < ActiveRecord::Migration[5.2]
  def change
    remove_index :photos, :primary
    remove_column :photos, :primary
  end
end
