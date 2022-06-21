class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.string :comment
      t.references :users, index: true, foreign_key: true
      t.references :tasks, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
