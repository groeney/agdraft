class Workers::EducationsController < Workers::BaseController
  def new
    @education = Education.new
  end

  def create
    @education = current_worker.educations.create(secure_params)
    unless @education.valid?
      flash[:error] = @education.errors.full_messages[0]
      return render :new
    end
    Analytics.track(
      user_id: current_worker.analytics_id,
      event: "Worker Created Education"
    )
    redirect_to worker_qualifications_path
  end

  def destroy
    education = current_worker.educations.find(params[:id])
    unless education.destroy
      return render_401
    end
    render_204
  end

  protected

  def secure_params
    params.require(:education)
          .permit(:school, :degree, :field_of_study, :description, :start_date, :end_date)
  end
end
