class Notification < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  has_attached_file :thumbnail, :styles => { :display => "200x200#" }, :default_url => "/assets/blank_user_photo.png"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/
end
