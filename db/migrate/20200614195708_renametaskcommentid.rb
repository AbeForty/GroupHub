class Renametaskcommentid < ActiveRecord::Migration
  def change
    rename_column :attachments, :tasks_id, :task_id
    rename_column :attachments, :comments_id, :comment_id
  end
end
