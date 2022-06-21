class OrganizationProjectEmailUser < ActiveRecord::Base
  belongs_to :Organization
  belongs_to :Project
end
