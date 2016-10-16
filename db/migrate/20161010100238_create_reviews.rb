class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :reviewee_id
      t.string :reviewee_type

      t.integer :reviewer_id
      t.string :reviewer_type

      t.integer :rating

      t.string :feedback
      t.timestamps null: false
    end
  end
end
