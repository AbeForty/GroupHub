class ChangeFileColumnToAttachment < ActiveRecord::Migration
  def change
    rename_column :attachments, :file, :attachment
  end
end
