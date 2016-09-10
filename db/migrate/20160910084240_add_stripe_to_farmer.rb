class AddStripeToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :stripe_customer_id, :string
    add_column :farmers, :stripe_delinquent, :boolean
  end
end
