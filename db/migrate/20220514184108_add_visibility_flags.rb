class AddVisibilityFlags < ActiveRecord::Migration
  def change
    add_reference :projects, :visibility_flags, index: true, foreign_key: true
  end
end
