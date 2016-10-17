class AddFarmNameToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :farm_name, :string
  end
end
