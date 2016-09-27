class Workers::JobWorkersController < Workers::BaseController
  def index
    @job_workers = JobWorker.where(worker_id: current_worker.id)
  end

  protected

  def nav_item
    @nav_item = "applications"
  end
end