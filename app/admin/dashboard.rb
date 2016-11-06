ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Workers" do
          ul do
            Worker.last(5).map do |worker|
              li link_to(worker.email, admin_worker_path(worker))
            end
          end
        end
      end

      column do
        panel "Recent Farmers" do
          ul do
            Farmer.last(5).map do |farmer|
              li link_to(farmer.email, admin_farmer_path(farmer))
            end
          end
        end
      end
    end
    columns do
      column do
        panel "Recent Previous Employers" do
          ul do
            PreviousEmployer.last(5).map do |prev|
              li link_to("#{prev.worker.full_name} worked at #{prev.business_name}", admin_previous_employer_path(prev))
            end
          end
        end
      end

      column do
        panel "Recently Published Jobs" do
          ul do
            Job.where(published: true).last(5).map do |job|
              li link_to(job.title, admin_job_path(job))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Recent Reviews" do
          ul do
            Review.last(5).map do |rev|
              li link_to("#{rev.reviewee.full_name}", admin_review_path(rev))
            end
          end
        end
      end
    end
  end

end
