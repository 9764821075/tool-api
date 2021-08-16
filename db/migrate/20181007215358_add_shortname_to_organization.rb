class AddShortnameToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :shortname, :string
  end
end
