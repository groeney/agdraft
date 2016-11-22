class WorkersController < ApplicationController
  layout "hero"
  def show
    @worker = Worker.find(params[:id])
    @jobs = current_farmer.jobs_for_worker(@worker.id) if current_farmer
    @jobs_applied_to = @jobs.select{|j| j[:invited]}
    @jobs_not_applied_to = @jobs.select{|j| !j[:invited]}
  end
end