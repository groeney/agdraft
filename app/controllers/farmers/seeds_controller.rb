class Farmers::SeedsController < Farmers::BaseController
  def spawn_workers
    return render_404 unless FactoryGirl.create_list(:worker, 5, :with_skills, :with_job_categories, :with_locations)
    render_201
  end

  def spawn_jobs
    return render_404 unless FactoryGirl.create_list(:job, 5, :with_job_categories, :with_skills, farmer: current_farmer)
    render_201
  end

  def hire
    unless current_farmer.jobs.count > 0
      FactoryGirl.create_list(:job, 10, :with_job_categories, :with_skills, farmer: current_farmer)
    end
    return render_404 unless grow_economy("hire")
    render_201
  end

  def shortlist
    unless current_farmer.jobs.count > 0
      FactoryGirl.create_list(:job, 10, :with_job_categories, :with_skills, farmer: current_farmer)
    end
    return render_404 unless grow_economy("shortlist")
    render_201
  end

  def attract
    unless current_farmer.jobs.count > 0
      FactoryGirl.create_list(:job, 10, :with_job_categories, :with_skills, farmer: current_farmer)
    end
    return render_404 unless grow_economy("express_interest")
    render_201
  end

  protected

  def grow_economy(state)
    job = current_farmer.jobs.find(params[:job_id])
    workers = job.recommended_workers
    JobWorker.create(job: job, worker: workers.sample).send(state + "!")
  end
end
