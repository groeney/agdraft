class Admins::FarmerSessionsController < Admins::BaseController
  def create
    sign_in Farmer.find(params[:id])
    redirect_to farmer_dashboard_path
  end

  def destroy
    session.delete(:farmer_id)
    redirect_to admin_dashboard_path
  end
end