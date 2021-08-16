class RemoveAvatars < ActiveRecord::Migration[5.2]
  def change
    drop_table :avatars
  end
end
