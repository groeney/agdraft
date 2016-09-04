class AddImageToWorker < ActiveRecord::Migration
  def change
    add_attachment :workers, :profile_photo
  end
end
