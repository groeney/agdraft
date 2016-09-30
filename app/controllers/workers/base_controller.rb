class Workers::BaseController < DashboardController
  acts_as_token_authentication_handler_for Worker
  before_filter :authenticate_worker

  def dashboard_type
    @dashboard_type = "workers"
  end

  def authenticate_worker
    authenticate_worker! if !current_admin
  end

  def current_worker
    if current_admin && session[:worker_id]
      Worker.find(session[:worker_id])
    else
      super
    end
  end
end