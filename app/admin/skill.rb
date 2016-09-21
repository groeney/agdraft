ActiveAdmin.register Skill do
  permit_params :title, job_category_ids: []
  actions :index, :show, :new, :create, :update, :edit

  index do
    selectable_column
    id_column
    column :title
    actions
  end

  filter :job_categories
  filter :title

  form do |f|
    f.inputs "Skill" do
      f.input :title
      f.inputs "Job Categoris" do
        f.input :job_categories, as: :check_boxes, collection: JobCategory.all
      end
    end
    f.actions
  end
end
