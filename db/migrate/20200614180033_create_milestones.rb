class CreateMilestones < ActiveRecord::Migration
  def change
    create_table :milestones do |t|
      t.string :tile
      t.string :description
      t.datetime :duedate
      t.references :projects, index: true, foreign_key: true
      t.references :users, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
