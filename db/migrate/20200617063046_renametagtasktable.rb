class Renametagtasktable < ActiveRecord::Migration
    def change
      rename_table :create_tag_task_tables, :tag_tasks
    end 
end
