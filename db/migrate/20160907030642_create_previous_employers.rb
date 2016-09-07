class CreatePreviousEmployers < ActiveRecord::Migration
  def change
    create_table :previous_employers do |t|
      # Employer specific
      t.string :business_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      # Worker specific
      t.integer :worker_id
      t.string  :job_title
      t.string  :job_description
      t.date    :start_date
      t.date    :end_date

      t.timestamps null: false
    end
  end
end
