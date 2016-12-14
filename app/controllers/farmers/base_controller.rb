class Farmers::BaseController < DashboardController
  acts_as_token_authentication_handler_for Farmer
  before_filter :authenticate_farmer!

  def dashboard_type
    @dashboard_type = "farmers"
  end
end