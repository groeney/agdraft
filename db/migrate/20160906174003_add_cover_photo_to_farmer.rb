class AddCoverPhotoToFarmer < ActiveRecord::Migration
  def change
    add_attachment :farmers, :cover_photo
  end
end
