class DeviseCreateFarmers < ActiveRecord::Migration
  def change
    create_table :farmers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps null: false

      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.string :referral_token
      t.integer :referral_user_id
      t.string  :referral_user_type
    end

    add_index :farmers, :email,                unique: true
    add_index :farmers, :reset_password_token, unique: true
    add_index :farmers, :confirmation_token,   unique: true
  end
end
