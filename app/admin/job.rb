ActiveAdmin.register Job do
  permit_params :farmer_id, :title, :description, :accomodation_provided, :business_name, :business_description, :location_id, :pay_min, :pay_max, :start_date, :end_date, :number_of_workers, :published, :live
  actions :index, :show, :update, :edit, :delete

  index do
    selectable_column
    id_column
    column :farmer
    column :title
    column :start_date
    column :location do |job|
      job.location.label
    end
    actions
  end

  filter :farmer_email, as: :string
  filter :title
  filter :start_date
  filter :location, member_label: :label

  form do |f|
    f.inputs "Job Details" do
      f.inputs :title 
      f.inputs :description 
      f.inputs :accomodation_provided 
      f.inputs :business_name 
      f.inputs :business_description 
      f.input :location, as: :select, collection: Location.all.map{|l| [l.label, l.id]}
      f.inputs :pay_min 
      f.inputs :pay_max 
      f.inputs :start_date 
      f.inputs :end_date 
      f.inputs :number_of_workers
      f.inputs :published 
      f.inputs :live
      f.inputs :archived
    end
    f.actions
  end

end
