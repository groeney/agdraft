class Admins::BaseController < DashboardController
  before_filter :authenticate_admin

  def dashboard_type
    @dashboard_type = "admins"
  end
end