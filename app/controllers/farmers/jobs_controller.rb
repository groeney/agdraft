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
    @jobs = current_farmer.jobs
  end

  def show
  end

  protected

  def nav_item
    @nav_item = "jobs"
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
end