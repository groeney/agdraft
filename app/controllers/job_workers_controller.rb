class JobWorkersController < ApplicationController
  acts_as_token_authentication_handler_for Worker, only: [:not_interested]
  before_filter :authenticate_worker!, only: [:express_interest, :not_interested]
  before_filter :authenticate_farmer!, only: [:shortlist, :index]
  before_filter :authenticate_user

  def index
    unless current_farmer.jobs.map{|j| j.id}.include?(params[:job_id].to_i)
      return render_401 "Farmer not authorized to access this record"
    end
    render json: JobWorker.where(job_id: params[:job_id]).to_json
  end

  def express_interest
    job_worker = JobWorker.create(job_id: params[:job_id], worker: current_worker)
    return render_400 unless job_worker.valid?
    job_worker.express_interest!
    render_201
  end

  def not_interested
    job_worker = current_worker.job_workers.where(id: params[:id]).first
    if !job_worker
      flash[:error] = "Unauthorized access" 
    elsif !job_worker.no_interest!
      flash[:error] = "This job record has already been updated"
    else
      flash[:success] = "Successfully updated your job application and notified the farmer that you are not interested in the job"
    end

    #this is to delete an unavailablity record if the worker was hired but then rejected the offer
    if unavailability = Unavailability.where(id: params[:unavailability_id], worker_id: current_worker.id).first
      unavailability.delete
    end

    return redirect_to root_url
  end

  def shortlist
    job_worker = JobWorker.create(job_id: params[:job_id], worker_id: params[:worker_id])
    return render_400 unless job_worker.valid?
    job_worker.shortlist!
    render_201
  end

  def transition
    job_worker = JobWorker.find(params[:job_worker_id])

    # Ensure user is authorized to make changes to this record
    return render_401 "Worker not authorized to modify this record" if current_worker && job_worker.worker_id != current_worker.id
    return render_401 "Farmer not authorized to modify this record" if current_farmer && !current_farmer.jobs.exists?(job_worker.job_id)

    # Worker can only call no_interest event
    return render_400 if current_worker && params[:transition] != "no_interest"
    return render_400 unless job_worker.send(params[:transition] + "!")
    render json: job_worker
  end

  protected

  def authenticate_user
    return render_401 "Unauthoirzed access. Must be signed in" if !current_worker && !current_farmer
  end
end
