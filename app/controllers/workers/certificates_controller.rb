class Workers::CertificatesController < Workers::BaseController
  def new
    @certificate = Certificate.new
  end

  def create
    @certificate = current_worker.certificates.create(secure_params)
    unless @certificate.valid?
      flash[:error] = @certificate.errors.full_messages[0]
      return render :new
    end
    redirect_to worker_qualifications_path
  end

  def destroy
    certificate = current_worker.certificates.find(params[:id])
    unless certificate.destroy
      return render_401
    end
    render_204
  end

  protected

  def secure_params
    params.require(:certificate)
          .permit(:title, :issuing_institution, :description, :issue_date, :end_date)
  end
end
