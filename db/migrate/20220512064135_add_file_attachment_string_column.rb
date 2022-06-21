class AddFileAttachmentStringColumn < ActiveRecord::Migration
  def change
    change_column :attachments, :file, :string
  end
end
