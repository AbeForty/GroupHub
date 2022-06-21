class AddCompanyIdToCompanyCodes < ActiveRecord::Migration
  def change
        add_reference :companycodes, :organizations, index: true, foreign_key: true
  end
end
