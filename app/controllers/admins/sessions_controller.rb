class Admins::SessionsController < Devise::SessionsController

  def after_sign_in_path_for(resource)
    admin_dashboard_path
  end
  
end
