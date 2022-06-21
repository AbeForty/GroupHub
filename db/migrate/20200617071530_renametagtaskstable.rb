class Renametagtaskstable < ActiveRecord::Migration
    def change
      rename_table :tag_task, :tag_tasks
    end 
end
