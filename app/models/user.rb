class User < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  has_many :projects
  has_many :waitinglist
  validates :name, presence: true
  validates :email, presence:true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
  before_save :downcase_fields
  def downcase_fields
    self.email.downcase!
  end
  has_secure_password
end
