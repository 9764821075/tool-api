class RemoveParentIdFromOrganization < ActiveRecord::Migration[5.2]
  def change
    remove_column :organizations, :parent_id
  end
end
