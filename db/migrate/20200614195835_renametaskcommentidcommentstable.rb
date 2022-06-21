class Renametaskcommentidcommentstable < ActiveRecord::Migration
  def change
    rename_column :comments, :tasks_id, :task_id
    rename_column :comments, :users_id, :user_id
  end
end
