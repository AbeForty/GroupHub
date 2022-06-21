class OrganizationProject < ActiveRecord::Base
  belongs_to :organization
  belongs_to :project
end
