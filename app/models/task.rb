class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  validates :title, presence: true
  validates :description, presence: true
  validates :duedate, presence: true
  validates :status, presence: true
end
