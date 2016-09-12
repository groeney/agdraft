class CreatePaymentAudits < ActiveRecord::Migration
  def change
    create_table :payment_audits do |t|
      t.references :farmer, index: true, foreign_key: true
      t.references :job, index: true, foreign_key: true
      t.string :action
      t.string :message
      t.boolean :success
      t.string :amount

      t.timestamps null: false
    end
  end
end
