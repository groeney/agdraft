class Admins::WorkerSessionsController < Admins::BaseController
  def create
    session[:worker_id] = id
    redirect_to worker_dashboard_path
  end

  def destroy
    session.delete(:worker_id)
    redirect_to admin_dashboard_path
  end
end