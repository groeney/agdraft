class AddHiddenToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :hidden, :boolean, default: false
  end
end
