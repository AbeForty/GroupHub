class Organization < ActiveRecord::Base
    mount_uploader :logo, AttachmentUploader # Tells rails to use this uploader for this model.
    validates :name, presence: true
    # validates :address, presence: true
    # validates :city, presence: true
    # validates :state, presence: true
    # validates :zipcode, presence: true
    # validates :logo, presence: true
    validates :headercolor, presence: true
    validates :headertextcolor, presence: true
    validates :bodytextcolor, presence: true
    validates :users_id, presence: true
end
