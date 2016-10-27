class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.integer :user_id
      t.string :user_type
      t.integer :resource_id
      t.string :resource_type
      t.boolean :blocked, default: false
      t.timestamps null: false
    end
  end
end
