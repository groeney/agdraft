include Rails.application.routes.url_helpers

namespace :jobs do
  task :archive_expired => :environment do
    Job.where("published_at <= ? AND published = ?", Time.now - 45.days, true).each {|j| j.archive }
  end 

  task :recommended_to_worker => :environment do
    if Time.now.wday == 1
      Worker.all.each do |worker|
        recommendations = worker.recommend_jobs(10).map {|j| {url: job_url(j.id), title: j.title, location: j.location_name} }
        if recommendations.length > 0
          EmailService.new.send_email(Rails.application.config.smart_email_ids[:jobs_recommended_to_worker], worker.email, {full_name: worker.full_name, jobs: recommendations})
        end
      end
    end
  end

   
end