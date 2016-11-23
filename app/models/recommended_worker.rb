class RecommendedWorker < ActiveRecord::Base
  belongs_to :job
  belongs_to :worker
end
