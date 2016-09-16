class AddDobToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :dob, :date
  end
end
