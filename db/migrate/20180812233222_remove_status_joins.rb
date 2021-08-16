class RemoveStatusJoins < ActiveRecord::Migration[5.2]
  def change
    drop_table :status_joins

    add_column :statuses, :statusable_id, :uuid
    add_column :statuses, :statusable_type, :string
  end
end
