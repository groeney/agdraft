namespace :jobs do
  namespace :archive_expired do
    Job.where("published_at <= ? AND published = ?", Time.now - 45.days, true).each {|j| j.archive }
  end 

  namespace :matching_worker_skills do
    if Time.now.wday == 1
      Worker.all.each do |worker|
        
      end
    end
  end
end