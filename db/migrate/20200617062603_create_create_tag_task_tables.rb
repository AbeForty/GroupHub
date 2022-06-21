class CreateCreateTagTaskTables < ActiveRecord::Migration
  def change
    create_table :create_tag_task_tables do |t|
      t.references :task, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
