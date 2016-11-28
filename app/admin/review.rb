ActiveAdmin.register Review do
  permit_params :rating, :feedback, :approved, :reviewee_type, :reviewee_id, :title, :work_ethic, :skills, :communication, :recommended
  actions :index, :show, :new, :create, :update, :edit

  index do
    selectable_column
    id_column
    column :reviewee
    column :reviewee_type
    column :overall_rating
    column :approved
    actions
  end

  filter :reviewee_type
  filter :reviewee_id
  filter :reviewer_type
  filter :reviewer_id
  filter :rating
  filter :approved

  form do |f|
    f.inputs "Review" do
      f.input :work_ethic, label: "Work Ethic (Worker only)"
      f.input :communication, label: "Communication (Worker only)"
      f.input :skills, label: "Skills (Worker only)"
      f.input :recommended, label: "Recommended (Worker only)"
      f.input :rating, label: "Rating (Farmer only)"
      f.input :feedback
      f.input :approved
      f.input :reviewee_type, collection: ["Worker", "Farmer"]
      f.input :reviewee_id
      f.input :title
    end
    f.actions
  end
end
