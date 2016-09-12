class Skill < ActiveRecord::Base
  validates_uniqueness_of :title
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :workers, -> { uniq }
end
