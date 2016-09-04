class Skill < ActiveRecord::Base
  has_and_belongs_to_many :job_categories, -> { uniq }
  has_and_belongs_to_many :workers, -> { uniq }
end
