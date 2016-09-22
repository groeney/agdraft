class AddVerifiedToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :verified, :boolean, default: false
  end
end
