class Rename < ActiveRecord::Migration
  def change
    rename_column :milestones, :tile, :title
  end
end
