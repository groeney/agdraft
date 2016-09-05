class Workers::OnboardController < Workers::BaseController
  layout "onboard"

  def job_categories
    @selected_job_categories = current_worker.job_categories
    @eligible_job_categories = current_worker.eligible_job_categories
  end

  def skills
    if current_worker.job_categories.count < 1
      flash[:notice] = "Please select a job category"
      redirect_to worker_onboard_job_categories_path
    end
    @selected_skills = current_worker.skills
    @eligible_skills = current_worker.eligible_skills
  end
end
