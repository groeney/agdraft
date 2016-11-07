ActiveAdmin.register Review do
  permit_params :rating, :feedback, :approved, :reviewee_type, :reviewee_id, :title
  actions :index, :show, :new, :create, :update, :edit

  index do
    selectable_column
    id_column
    column :reviewee
    column :rating
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
      f.input :rating
      f.input :feedback
      f.input :approved
      f.input :reviewee_type, collection: ["Worker", "Farmer"]
      f.input :reviewee_id
      f.input :title
    end
    f.actions
  end
end
