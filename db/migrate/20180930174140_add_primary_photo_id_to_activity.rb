class AddPrimaryPhotoIdToActivity < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :primary_photo_id, :uuid
    add_index :activities, :primary_photo_id
  end
end
