class AddMilestoneToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :milestone, index: true, foreign_key: true
  end
end
