class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :resource_id
      t.string :resource_type
      t.string :action_path, default: "#"
      t.attachment :thumbnail
      t.string :header, default: ""
      t.string :description, default: ""
      t.boolean :unseen, default: true
      t.timestamps null: false
    end
  end
end
