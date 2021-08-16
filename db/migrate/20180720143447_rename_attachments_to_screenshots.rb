class RenameAttachmentsToScreenshots < ActiveRecord::Migration[5.2]
  def change
    rename_table :attachments, :screenshots

    remove_index :attachment_joins, name: "index_attachment_joins_on_attachmentable_id_and_type"

    rename_table :attachment_joins, :screenshot_joins

    rename_column :screenshot_joins, :attachment_id, :screenshot_id
    rename_column :screenshot_joins, :attachmentable_id, :screenshotable_id
    rename_column :screenshot_joins, :attachmentable_type, :screenshotable_type

    add_index :screenshot_joins, [:screenshotable_id, :screenshotable_type], name: "index_screenshot_joins_on_screenshotable_id_and_type"
  end
end
