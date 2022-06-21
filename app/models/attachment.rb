class Attachment < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  belongs_to :task
  belongs_to :comment
end
