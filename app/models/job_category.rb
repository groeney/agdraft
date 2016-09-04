class JobCategory < ActiveRecord::Base
  has_and_belongs_to_many :skills, -> { uniq }
  has_and_belongs_to_many :workers, -> { uniq }
end
