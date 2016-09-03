class AddFieldsToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :referral_user_id, :integer
    add_column :workers, :referral_user_type, :string
    remove_column :workers, :referred_by_token, :string
    add_column :workers, :confirmation_token, :string
    add_column :workers, :confirmed_at, :datetime
    add_column :workers, :confirmation_sent_at, :datetime
    add_index :workers, :confirmation_token,   unique: true
  end
end
