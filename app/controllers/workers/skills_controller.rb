class Workers::SkillsController < Workers::BaseController
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

  def secure_params
    params.require(:skill).permit(:id)
  end
end
