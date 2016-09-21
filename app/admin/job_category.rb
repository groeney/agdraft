ActiveAdmin.register JobCategory do
  permit_params :title
  actions :index, :show, :new, :create, :update, :edit

  index do
    selectable_column
    id_column
    column :title
    actions
  end

  form do |f|
    f.inputs "Job Category" do
      f.input :title    
    end
    f.actions
  end
end
