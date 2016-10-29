class AddJobToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :job_id, :integer
  end
end
