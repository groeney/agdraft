class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :state, null: false
      t.string :region, null: false

      t.timestamps null: false
    end
  end
end
