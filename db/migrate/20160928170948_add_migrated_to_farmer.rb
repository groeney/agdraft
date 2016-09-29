class AddMigratedToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :migrated, :boolean, default: false
  end
end
