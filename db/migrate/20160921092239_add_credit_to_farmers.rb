class AddCreditToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :credit, :integer, default: 0
  end
end
