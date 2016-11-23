class CreateRecommendedWorkers < ActiveRecord::Migration
  def change
    create_table :recommended_workers do |t|
      t.references :job, index: true, foreign_key: true
      t.references :worker, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
