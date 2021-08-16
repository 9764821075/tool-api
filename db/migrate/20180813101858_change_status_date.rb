class ChangeStatusDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :statuses, :status_date

    add_column :statuses, :date_day, :integer
    add_column :statuses, :date_month, :integer
    add_column :statuses, :date_year, :integer
  end
end
