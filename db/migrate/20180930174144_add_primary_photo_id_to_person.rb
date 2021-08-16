class AddPrimaryPhotoIdToPerson < ActiveRecord::Migration[5.2]
  def change
    add_column :people, :primary_photo_id, :uuid
    add_index :people, :primary_photo_id
  end
end
