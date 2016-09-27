class JobWorkerSerializer < ActiveModel::Serializer
  attributes :id, :state
  belongs_to :worker, serializer: WorkerSerializer
end