class JobCategory < ActiveRecord::Base
  validates_uniqueness_of :title
  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :workers, -> { uniq }

  has_attached_file :image, :styles => { :display => "300x300#" }, :default_url => "/assets/job_category_images/livestock.jpg"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
