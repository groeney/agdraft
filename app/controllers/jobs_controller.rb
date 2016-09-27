class JobsController < ApplicationController
  layout "hero"
  def show
    @job = Job.find(params[:id])
    @applied = !JobWorker.where(job_id: params[:id], worker_id: current_worker.id).empty? if current_worker
  end
end