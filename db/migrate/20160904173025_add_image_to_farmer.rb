class AddImageToFarmer < ActiveRecord::Migration
  def change
    add_attachment :farmers, :profile_photo
  end
end
