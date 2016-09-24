class WorkersController < ApplicationController
  def show
    @worker = Worker.find(params[:id])
    @jobs = current_farmer.jobs_for_worker(@worker.id) if current_farmer
  end
end