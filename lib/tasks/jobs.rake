include Rails.application.routes.url_helpers

namespace :jobs do
  # Archive jobs after 45 days - this is the time limit specified by Ella for when a job should expire
  task :archive_expired => :environment do
    Job.where("published_at <= ? AND published = ?", Time.now - 45.days, true).each {|j| j.archive }
  end 

  # Every week an email should be sent to all workers showing them a list of recommended jobs on AgDraft
  task :recommended_to_worker => :environment do
    if Time.now.wday == 1
      Worker.all.each do |worker|
        recommendations = worker.recommend_jobs(10).map {|j| {url: job_url(j.id), title: j.title, location: j.location_name} }
        if recommendations.length > 0
          EmailService.new.send_email(Rails.application.config.smart_email_ids[:weekly_jobs_recommended_to_worker], worker.email, {full_name: worker.full_name, jobs: recommendations, dashboard_url: worker_dashboard_url})
        end
      end
    end
  end

  # Once a job has finished (not expired) based on the listed end_date of the job, send every worker who was hired an e-mail
  # asking them to review the farmer
  task :completed => :environment do
    Job.where("end_date <= ? AND published = ?", Time.now, true).each do |job|
      job.archive
      JobWorker.where(job_id: job.id, state: "hired").each do |job_worker|
        worker = job_worker.worker
        EmailService.new.send_email(Rails.application.config.smart_email_ids[:request_job_review], worker.email, {full_name: worker.full_name, url: worker_new_farmer_review_url(job.farmer_id), job_title: job.title, location: job.location_name})
      end
    end
  end

  # Every day check to see if there are new recommended workers for a job and e-mail the farmer if there are
  task :new_recommended_workers => :environment do
    job = Job.where(archived: false, published: true).each do |job|
      recommended_workers = job.check_for_new_recommended_workers.map{|worker| {full_name: worker.full_name, profile_url: worker_url(worker.id)}}
      EmailService.new.send_email(Rails.application.config.smart_email_ids[:new_recommended_workers_for_job], job.farmer.email, {job_title: job.title, recommened_workers: recommended_workers, manage_job_url: farmer_manage_job_url(job.id)}) if !recommended_workers.empty?
    end
  end

   
end