class AddOwnerToOrganization < ActiveRecord::Migration
  def change
    add_reference :organizations, :users, index: true, foreign_key: true
  end
end
