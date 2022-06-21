class RenameprojectsIDtoProjectId < ActiveRecord::Migration
  def change
    rename_column :milestones, :projects_id, :project_id
    rename_column :milestones, :users_id, :user_id
  end
end
