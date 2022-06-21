class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :logo
      t.string :headercolor
      t.string :headertextcolor
      t.string :bodytextcolor

      t.timestamps null: false
    end
  end
end
