class JobCategory < ActiveRecord::Base
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :workers
end
