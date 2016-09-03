class Farmers::BaseController < DashboardController
  before_filter :authenticate_farmer

  def dashboard_type
    @dashboard_type = "farmers"
  end
  
  def authenticate_farmer
    authenticate_farmer! if !current_admin
  end

  def current_farmer
    if current_admin && session[:farmer_id]
      Farmer.find(session[:farmer_id])
    else
      super
    end
  end
end