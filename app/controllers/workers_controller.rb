class WorkersController < ApplicationController
  def show
    @worker = Worker.find(params[:id])
    if current_farmer
      @jobs = current_farmer.jobs.where(published: true).map{|j| {job: j, invited: !JobWorker.where(job_id: j.id, worker_id: @worker.id).empty? } }
    end
  end
end