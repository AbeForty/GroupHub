class RemoveuserFromMilestone < ActiveRecord::Migration
  def change
    remove_column :milestones, :user_id, :integer
  end
end
