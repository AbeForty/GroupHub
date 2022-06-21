class AddPriorityToTask < ActiveRecord::Migration
  def change
    add_reference :tasks, :PriorityType, index: true, foreign_key: true
  end
end
