class Admins::FarmerSessionsController < Admins::BaseController
  def create
    session[:farmer_id] = params[:id]
    redirect_to farmer_dashboard_path
  end

  def destroy
    session.delete(:farmer_id)
    redirect_to admin_dashboard_path
  end
end