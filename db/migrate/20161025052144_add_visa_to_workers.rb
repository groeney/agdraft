class AddVisaToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :visa, :string
    add_column :workers, :visa_number, :string
  end
end
