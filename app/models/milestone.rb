class Milestone < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :projects, source: :project, dependent: :destroy
  has_many :tasks, source: :task, dependent: :destroy
end
