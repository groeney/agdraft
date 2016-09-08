class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string  :school
      t.string  :degree
      t.string  :field_of_study
      t.string  :description
      t.integer :worker_id
      t.date    :start_date
      t.date    :end_date

      t.timestamps null: false
    end
  end
end
