class CreatePriorityTypes < ActiveRecord::Migration
  def change
    create_table :priority_types do |t|
      t.string :title
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
