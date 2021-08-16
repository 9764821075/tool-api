class RemoveShortnameFromOrganization < ActiveRecord::Migration[5.2]
  def change
    remove_column :organizations, :shortname, :string
  end
end
