class CreateUnavailabilities < ActiveRecord::Migration
  def change
    create_table :unavailabilities do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :worker_id

      t.timestamps null: false
    end
  end
end
