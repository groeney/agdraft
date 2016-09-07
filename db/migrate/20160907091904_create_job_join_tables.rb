class CreateJobJoinTables < ActiveRecord::Migration
  def change
    create_join_table :jobs, :workers do |t|
    end
    create_join_table :jobs, :skills do |t|
    end
    create_join_table :jobs, :job_categories do |t|
    end
  end
end
