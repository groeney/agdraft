class DeviseCreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      ## AgDraft required fields
      t.string :first_name, null: false, default: ""
      t.string :last_name, null: false, default: ""
      t.boolean :has_own_transport, null: false, default: false

      ## AgDraft optional fields
      t.string :referred_by_token
      t.string :referral_token
      t.string :tax_file_number
      t.string :mobile_number
      t.string :nationality

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

      t.timestamps null: false
    end

    add_index :workers, :email,                unique: true
    add_index :workers, :reset_password_token, unique: true
  end
end
