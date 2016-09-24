class WorkerSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :profile_photo_url

  def profile_photo_url
    object.profile_photo.url(:display)
  end
end