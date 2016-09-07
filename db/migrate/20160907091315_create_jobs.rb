class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.references :farmer, index: true, foreign_key: true
      t.string :title
      t.text :description
      t.boolean :accomodation_provided
      t.string :business_name
      t.text :business_description
      t.references :location, index: true, foreign_key: true
      t.string :pay_min
      t.string :pay_max
      t.timestamp :start_date
      t.timestamp :end_date
      t.string :number_of_workers
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end
