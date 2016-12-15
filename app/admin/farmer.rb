ActiveAdmin.register Farmer do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :location, :business_name, :business_description, :contact_name, :contact_number, :credit, :sign_in_count
  actions :index, :show, :update, :edit, :delete
  
  index do
    selectable_column
    id_column
    column :email
    column :last_name
    column :first_name
    column :business_name
    column :location do |farmer|
      farmer.location.try(:label)
    end
    actions
  end

  filter :email
  filter :last_name
  filter :first_name
  filter :business_name
  filter :location, member_label: :label

  form do |f|
    f.inputs "Farmer Details" do
      f.input :email
      f.input :password
      f.input :first_name
      f.input :last_name
      f.input :location, as: :select, collection: Location.all.map{|l| [l.label, l.id]}
      f.input :business_name
      f.input :business_description
      f.input :contact_name
      f.input :contact_number
      f.input :credit
      f.input :sign_in_count
    end
    f.actions
  end

  sidebar "Details", only: :show do
    attributes_table_for farmer do
      row :jobs do
        link_to "#{farmer.jobs.length} listed jobs", :controller => "jobs", :action => "index", 'q[farmer_email_equals]' => "#{farmer.email}".html_safe
      end
      row :god_mode do
        link_to "Access Account", {:controller => "admins/farmer_sessions", :action => "create", :id => farmer.id}, target: "_blank"
      end
      row :reviews_by do
        link_to "Reviews BY farmer", :controller => "reviews", :action => "index", 'q[reviewer_type_equals]' => "Farmer", "q[reviewer_id_equals]" => "#{farmer.id}"
      end
      row :reviews_of do
        link_to "Reviews OF farmer", :controller => "reviews", :action => "index", 'q[reviewee_type_equals]' => "Farmer", "q[reviewee_id_equals]" => "#{farmer.id}"
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
