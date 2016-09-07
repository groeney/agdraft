class Workers::PreviousEmployersController < Workers::BaseController
  def new
    @previous_employer = PreviousEmployer.new
  end

  def index
    @previous_employers = current_worker.previous_employers
  end

  def create
    @previous_employer = current_worker.previous_employers.create(secure_params)
    unless @previous_employer.valid?
      flash[:error] = @previous_employer.errors.full_messages[0]
      return render :new
    end
    redirect_to worker_previous_employers_path
  end

  def destroy
    previous_employer = current_worker.previous_employers.find(params[:id])
    unless previous_employer.destroy
      return render_401
    end
    render_204
  end

  protected

  def secure_params
    params.require(:previous_employer)
          .permit(:business_name, :contact_name, :contact_phone, :contact_email, :job_title, :job_description, :start_date, :end_date)
  end
end
