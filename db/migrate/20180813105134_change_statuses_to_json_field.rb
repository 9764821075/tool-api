class ChangeStatusesToJsonField < ActiveRecord::Migration[5.2]
  def change
    drop_table :statuses

    add_column :organization_addresses, :statuses, :jsonb, null: false, default: []
  end
end
