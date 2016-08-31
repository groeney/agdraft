class CreateJoinTableJobCategoriesWorkers < ActiveRecord::Migration
  def change
    create_join_table :job_categories, :workers do |t|
    end
  end
end
