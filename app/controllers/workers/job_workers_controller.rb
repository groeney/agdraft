class Workers::JobWorkersController < Workers::BaseController
  def index
    @job_workers = current_worker.job_workers
  end

  protected

  def nav_item
    @nav_item = "applications"
  end
end