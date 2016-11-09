class Notification < ActiveRecord::Base
  belongs_to :resource, polymorphic: true
  has_attached_file :thumbnail, :styles => { :display => "200x200#" }, :default_url => "/assets/agdraft-logo.png"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/
end
