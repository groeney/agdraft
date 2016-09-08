class AddFieldsToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :business_name, :string
    add_column :farmers, :business_description, :text
    add_column :farmers, :contact_name, :string
    add_column :farmers, :contact_number, :string
  end
end
