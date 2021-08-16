class EnableUnaccentExtension < ActiveRecord::Migration[5.2]
  def up
    execute "create extension if not exists unaccent;"
  end

  def down
    execute "drop extension if exists unaccent;"
  end
end
