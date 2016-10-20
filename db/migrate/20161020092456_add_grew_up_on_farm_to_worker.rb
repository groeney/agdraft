class AddGrewUpOnFarmToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :grew_up_on_farm, :boolean, default: false
  end
end
