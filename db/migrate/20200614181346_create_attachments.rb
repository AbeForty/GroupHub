class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.binary :file
      t.references :tasks, index: true, foreign_key: true
      t.references :comments, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
