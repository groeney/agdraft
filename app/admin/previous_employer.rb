ActiveAdmin.register PreviousEmployer do
  permit_params :business_name, :contact_name, :contact_email, :contact_phone, :worker_id, :job_title, :job_description, :start_date, :end_date
  actions :index, :show, :update, :edit

  index do
    selectable_column
    id_column
    column :worker do |prev|
      prev.worker.email
    end
    column :business_name
    column :job_title
    column :job_description
    actions
  end

  filter :worker, member_label: :email
  filter :business_name
end
