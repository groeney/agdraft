ActiveAdmin.register Worker do
  permit_params :verified, :email, :password
  actions :index, :show, :update, :edit, :delete
  
  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :last_name
  filter :first_name
  filter :locations, member_label: :label

  form do |f|
    f.inputs "Worker Verified" do
      f.input :email
      f.input :password
      f.input :verified
    end
    f.actions
  end

  sidebar "Details", only: :show do
    attributes_table_for worker do
      row :god_mode do
        link_to "Access Account", :controller => "admins/worker_sessions", :action => "create", :id => worker.id
      end
    end
  end

  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end

end
