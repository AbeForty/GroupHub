class RenameTileToTitleStatus < ActiveRecord::Migration
  def change
    rename_column :status_types, :tile, :title
  end
end
