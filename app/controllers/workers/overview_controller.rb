class Workers::OverviewController < Workers::BaseController
  def index
    if !current_worker.verified
      flash[:alert] = "<div class='header'>Unverified Account</div><p>You're account is not currently verified which decreases your chance of being matched with jobs. In order for us to verify your account we need to do a reference check. Please create a Previous Experience record by clicking on the link in the side bar. Once created, we will verify the information provided</p>"
    end
    @recommendations = current_worker.job_recommendations
    @notifications = current_worker.notifications.where({ unseen: true }).reverse
  end
end