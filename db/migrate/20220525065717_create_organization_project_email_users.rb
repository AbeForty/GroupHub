class CreateOrganizationProjectEmailUsers < ActiveRecord::Migration
  def change
    create_table :organization_project_email_users do |t|
      t.references :Organization, index: true, foreign_key: true
      t.references :Project, index: true, foreign_key: true
      t.string :email

      t.timestamps null: false
    end
  end
end
