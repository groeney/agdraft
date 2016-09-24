class CreateJobWorkers < ActiveRecord::Migration
  def change
    create_table :job_workers do |t|
      t.references :job, index: true, foreign_key: true
      t.references :worker, index: true, foreign_key: true
      t.string :state

      t.timestamps null: false
    end
  end
end
