class Farmers::JobsController < Farmers::BaseController
  def new
    @job = Job.new
  end

  def create
    @job = current_farmer.jobs.create(secure_params)
    @job.skills << Skill.find(skills_params)
    @job.job_categories << JobCategory.find(job_categories_params)

    unless @job.valid?
      return render "new"
    end
    notify_eligible_workers
    redirect_to farmer_jobs_path
  end

  def edit
    @job = current_farmer.jobs.find(params[:id])
    return redirect_to farmer_jobs_path if @job.nil?
  end

  def update
    @job = Job.find(params[:id])
    @job.skills = Skill.find(skills_params)
    @job.job_categories = JobCategory.find(job_categories_params)
    unless @job.update_attributes(secure_params)
      return render "edit"
    end
    redirect_to farmer_jobs_path
  end

  def index
    @jobs = current_farmer.jobs.where(published: false)
  end

  def published
    @jobs = current_farmer.jobs.where(published: true)
    @nav_item = "jobs_published"
  end

  def show
  end

  def publish_confirm
    @job = Job.find(params[:id])
    return redirect_to farmer_published_jobs_path if @job.published
  end

  def publish
    @job = Job.find(params[:id])
    if @job.publish
      flash[:success] = "You have successfully published your job advertisment. An e-mail receipt will be delivered to you shortly"
      redirect_to farmer_published_jobs_path
    else
      flash[:error] = "There was a problem processing your payment, please make sure your payment information is valid and try again"
      render "publish_confirm"
    end
  end

  def live
    job = Job.find(params[:id])
    job.update_attribute(:live, !job.live)
    render_201
  end

  def manage
    @job = Job.find(params[:id])
    @nav_item = "jobs_published"
  end

  def recommended_workers
    job = current_farmer.jobs.find(params[:id])
    render json: job.recommended_workers
  end

  protected

  def nav_item
    @nav_item = "jobs_unpublished"
  end

  def secure_params
    params.require(:job).permit(:title, :description, :location_id, :accomodation_provided, :pay_min, :pay_max, :start_date, :end_date, :number_of_workers)
  end

  def skills_params
    params.require(:job).permit(:skills => [])["skills"].reject{|i| i.empty? }
  end

  def job_categories_params
    params.require(:job).permit(:job_categories => [])["job_categories"].reject{|i| i.empty? }
  end

  def job_params
    { skills: skills_params, job_categories: job_categories_params }
  end

  def notify_eligible_workers
    Worker.filter_and(job_params).each do |worker|
      Notification.create(resource: worker,
                          action_path: job_path(@job.id),
                          thumbnail: @job.farmer.profile_photo,
                          header: "A new job was added that matches your skills!",
                          description: "#{@job.farmer.full_name} just listed a job that is just right for you."
                          )
    end
  end
end