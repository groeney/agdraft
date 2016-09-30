class AddDescriptionToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :description, :string, default: ""
  end
end
