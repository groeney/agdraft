class Workers::SessionsController < Devise::SessionsController
  before_filter :old_user, only: [:create]

  def after_sign_in_path_for(resource)
    Analytics.track(
      user_id: current_worker.analytics_id,
      event: "Signin"
      )
    worker_dashboard_path
  end

  protected

  def old_user
    @worker = Worker.find_by_email(params["worker"]["email"])
    # Is this an old user who has not yet signed in to the new app?
    if @worker && @worker.last_sign_in_at.nil?
      @worker.send_reset_password_instructions
      return render "includes/welcome_to_new_app", layout: "onboard"
    end
  end

end
