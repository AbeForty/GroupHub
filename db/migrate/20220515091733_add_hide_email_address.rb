class AddHideEmailAddress < ActiveRecord::Migration
  def change
    add_column :users, :hideEmail, :integer
  end
end
