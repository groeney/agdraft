class Farmers::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    Analytics.track(
      user_id: current_farmer.analytics_id,
      event: "Signin"
      )

    farmer_dashboard_path
  end

end
