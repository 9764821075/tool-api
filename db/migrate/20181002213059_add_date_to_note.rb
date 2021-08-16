class AddDateToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :date, :date
  end
end
