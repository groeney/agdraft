class Workers::SkillsController < Workers::BaseController
  def index
    @selected_skills = current_worker.skills
    @eligible_skills = current_worker.eligible_skills
    if current_worker.job_categories.count < 1
      flash[:error] = "Please select a job category"
      return redirect_to worker_job_categories_path
    end
  end

  def create
    current_worker.skills << Skill.find_by!(secure_params)
    render_201
  end

  def destroy
    skill = current_worker.skills.find(params[:id])
    if current_worker.skills.destroy(skill)
      return render_204
    end
    render_404
  end

  protected

  def nav_item
    @nav_item = "skills"
  end

  def secure_params
    params.require(:skill).permit(:id)
  end
end
