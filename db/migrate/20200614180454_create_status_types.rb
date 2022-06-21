class CreateStatusTypes < ActiveRecord::Migration
  def change
    create_table :status_types do |t|
      t.string :tile
      t.string :color

      t.timestamps null: false
    end
  end
end
