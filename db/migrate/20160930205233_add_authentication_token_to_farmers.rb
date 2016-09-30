class AddAuthenticationTokenToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :authentication_token, :string, limit: 30
    add_index :farmers, :authentication_token, unique: true
  end
end
