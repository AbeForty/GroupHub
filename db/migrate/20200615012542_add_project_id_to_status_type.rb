class AddProjectIdToStatusType < ActiveRecord::Migration
  def change
    add_reference :status_types, :project, index: true, foreign_key: true
  end
end
