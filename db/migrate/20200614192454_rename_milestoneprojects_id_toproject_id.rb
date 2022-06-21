class RenameMilestoneprojectsIdToprojectId < ActiveRecord::Migration
  def change
    rename_column :milestone, :projects_id, :project_id
    rename_column :milestone, :users_id, :user_id
  end
end
