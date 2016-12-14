class Workers::BaseController < DashboardController
  acts_as_token_authentication_handler_for Worker
  before_filter :authenticate_worker!

  def dashboard_type
    @dashboard_type = "workers"
  end
end