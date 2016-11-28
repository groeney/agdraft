class AddRecommendedToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :recommended, :integer
  end
end
