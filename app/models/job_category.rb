class JobCategory < ActiveRecord::Base
  validates_uniqueness_of :title
  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :workers, -> { uniq }
end
