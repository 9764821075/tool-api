class AddTitleToNote < ActiveRecord::Migration[5.2]
  def change
    add_column :notes, :title, :text
  end
end
