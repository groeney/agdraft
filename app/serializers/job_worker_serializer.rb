class JobWorkerSerializer < ActiveModel::Serializer
  attributes :id, :state, :worker_id, :full_name, :profile_photo_url, :mobile_number
  
  def full_name
    object.worker.full_name
  end

  def profile_photo_url
    object.worker.profile_photo.url(:display)
  end

  def mobile_number
    object.worker.mobile_number
  end
end