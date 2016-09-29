class AddMigratedToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :migrated, :boolean, default: false
  end
end
