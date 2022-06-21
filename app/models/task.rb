class Task < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :milestone
  # belongs_to :tagtask
  has_many :comments, source: :comment, dependent: :destroy
  # has_many :tags, through: :tagtask, dependent: :destroy
  validates :title, presence: true
  validates :description, presence: true
  # validates :duedate, presence: true
  validates :status, presence: true
end