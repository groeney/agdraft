class WorkersController < ApplicationController
  layout "hero"
  def show
    @worker = Worker.find(params[:id])
    @recent_jobs = JobWorker.where(worker_id: @worker.id, state: "hired")
    if current_farmer
      @jobs = current_farmer.jobs_for_worker(@worker.id)
      @jobs_applied_to = @jobs.select{|j| j[:invited]}
      @jobs_not_applied_to = @jobs.select{|j| !j[:invited]}
    end
  end
end