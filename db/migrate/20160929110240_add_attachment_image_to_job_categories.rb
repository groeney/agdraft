class AddAttachmentImageToJobCategories < ActiveRecord::Migration
  def self.up
    change_table :job_categories do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :job_categories, :image
  end
end
