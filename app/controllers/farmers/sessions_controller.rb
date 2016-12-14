class Farmers::SessionsController < Devise::SessionsController
  before_filter :old_user, only: [:create]

  def after_sign_in_path_for(resource)
    Analytics.track(
      user_id: current_farmer.analytics_id,
      event: "Signin"
      )

    farmer_dashboard_path
  end

  protected

  def old_user
    @farmer = Farmer.find_by_email(params["farmer"]["email"])
    # Is this an old user who has not yet signed in to the new app?
    if @farmer && @farmer.sign_in_count == 0
      @farmer.send_reset_password_instructions
      return render "includes/welcome_to_new_app", layout: "onboard"
    end
  end
end
