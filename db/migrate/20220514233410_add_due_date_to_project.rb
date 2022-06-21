class AddDueDateToProject < ActiveRecord::Migration
  def change
    add_column :projects, :duedate, :date
  end
end
