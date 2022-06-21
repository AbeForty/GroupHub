class Project < ActiveRecord::Base
  has_many :members, dependent: :destroy
  has_many :milestones, source: :milestone, dependent: :destroy
  has_many :users, through: :members, dependent: :destroy
  has_many :waitinglist, dependent: :destroy
  has_many :waitlisters, through: :waitinglist, source: :user, dependent: :destroy
  has_many :status_type, dependent: :destroy
  has_many :tasks, dependent: :destroy
  belongs_to :user
  validates :title, presence: true
  validates :description, presence: true
end
