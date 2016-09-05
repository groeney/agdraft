class CreateWorkerLocations < ActiveRecord::Migration
  def change
    create_join_table :locations, :workers do |t|
      t.index [:location_id, :worker_id]
      t.index [:worker_id, :location_id]
    end
  end
end
