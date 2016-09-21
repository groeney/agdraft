class ChangeValueOfAmountOnPaymentAudits < ActiveRecord::Migration
  def change
    remove_column :payment_audits, :amount
    add_column :payment_audits, :amount, :integer, default: 0
  end
end
