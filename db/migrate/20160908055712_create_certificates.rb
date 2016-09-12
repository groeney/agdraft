class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.string  :title
      t.date    :issue_date
      t.string  :issuing_institution
      t.string  :description
      t.integer :worker_id

      t.timestamps null: false
    end
  end
end
