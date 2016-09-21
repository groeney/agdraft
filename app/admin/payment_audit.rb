ActiveAdmin.register PaymentAudit do
  actions :index

  index do
    selectable_column
    id_column
    column :farmer
    column :job do |pa|
      pa.job.try(:title)
    end
    column :action
    column :amount
    column :message
    column :success
  end

  filter :farmer_email, as: :string
  filter :job_title, as: :string
end