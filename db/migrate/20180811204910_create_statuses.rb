class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses, id: :uuid do |t|
      t.integer :status_type
      t.datetime :status_date

      t.boolean :deleted, default: false
      t.timestamps null: false
    end

    create_table :status_joins, id: :uuid do |t|
      t.uuid :status_id
      t.uuid :statusable_id
      t.string :statusable_type

      t.boolean :deleted, default: false
      t.timestamps null: false
    end

    add_index :status_joins, [:statusable_id, :statusable_type]
  end
end
