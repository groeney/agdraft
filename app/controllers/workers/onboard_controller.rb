class Workers::OnboardController < Workers::BaseController
  layout "onboard"

  def job_categories
    @selected_job_categories = current_worker.job_categories
    @eligible_job_categories = current_worker.eligible_job_categories
  end

  def skills
    if current_worker.job_categories.count < 1
      flash[:error] = "Please select a job category"
      redirect_to worker_onboard_job_categories_path
    end
    @selected_skills = current_worker.skills
    @eligible_skills = current_worker.eligible_skills
  end

  def locations
    @worker_locations = current_worker.locations
    @all_locations = Location.all
  end

  def finish
    notify_farmers
    redirect_to worker_dashboard_path
  end

  protected

  def notify_farmers
    notified_farmer_ids = []
    current_worker.job_recommendations.each do |recommendation|
      job = recommendation.resource
      unless notified_farmer_ids.include? job.farmer.id
        Notification.create(resource: job.farmer,
                            action_path: worker_path(current_worker.id),
                            thumbnail: current_worker.profile_photo,
                            header: "Worker recommendation",
                            description: "#{current_worker.full_name} just signed up and their skillset matches one of your jobs. Invite them to apply!"
                            )
      end
      notified_farmer_ids.append(job.farmer.id)
    end
  end
end
