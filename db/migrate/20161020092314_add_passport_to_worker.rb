class AddPassportToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :passport_number, :string
  end
end
