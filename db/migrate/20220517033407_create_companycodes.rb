class CreateCompanycodes < ActiveRecord::Migration
  def change
    create_table :companycodes do |t|
      t.string :code

      t.timestamps null: false
    end
  end
end
