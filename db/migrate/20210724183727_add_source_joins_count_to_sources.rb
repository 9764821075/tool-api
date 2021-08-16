class AddSourceJoinsCountToSources < ActiveRecord::Migration[5.2]
  def change
    unless ActiveRecord::Base.connection.column_exists?(:sources, :source_joins_count)
      add_column :sources, :source_joins_count, :integer
    end
  end
end
