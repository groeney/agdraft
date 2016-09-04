class Workers::ProfilePhotosController < Workers::BaseController
  def show
    @worker = current_worker
  end

  def edit
    @worker = current_worker
  end

  def update
    @worker = current_worker
    if @worker.update_attributes(worker_params)
      render "show"
    else
      render "edit"
    end
  end

  protected

  def nav_item
    @nav_item = "profile_photo"
  end

  def worker_params
    params.require(:worker).permit(:profile_photo)
  end
end