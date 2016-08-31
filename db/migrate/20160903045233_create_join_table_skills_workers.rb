class CreateJoinTableSkillsWorkers < ActiveRecord::Migration
  def change
    create_join_table :skills, :workers do |t|
    end
  end
end
