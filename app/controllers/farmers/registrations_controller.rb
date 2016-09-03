class Farmers::RegistrationsController < Devise::RegistrationsController

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    farmer_dashboard_path
  end
end
