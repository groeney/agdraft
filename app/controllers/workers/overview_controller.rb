class Workers::OverviewController < Workers::BaseController
  def index
    flash[:alert] = "<div class='header'>Unverified Account</div><p>You're account is not currently verified which decreases your chance of being matched with jobs. In order for us to verify your account we need to do a reference check. Please create a Previous Employer record by clicking on the link in the side bar. Once created, it will take us 3-5 buiness days to verify the information provided</p>" if !current_worker.verified
    @recommended_jobs = current_worker.recommended_jobs
    @notifications = current_worker.notifications.where({ unseen: true }).reverse
  end
end