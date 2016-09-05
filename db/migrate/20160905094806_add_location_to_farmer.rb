class AddLocationToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :location_id, :integer
  end
end
