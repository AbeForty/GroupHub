class CreateVisibilityFlags < ActiveRecord::Migration
  def change
    create_table :visibility_flags do |t|
      t.string :flag
      t.timestamps null: false
    end
  end
end
