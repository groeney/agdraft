class AddFieldsToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :skills, :integer
    add_column :reviews, :communication, :integer
    add_column :reviews, :work_ethic, :integer
  end
end
