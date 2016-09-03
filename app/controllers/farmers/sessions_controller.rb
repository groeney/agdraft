class Farmers::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    farmer_dashboard_path
  end

end
