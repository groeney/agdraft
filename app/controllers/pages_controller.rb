class PagesController < ApplicationController
  def home
    redirect_to worker_dashboard_path if current_worker
    redirect_to farmer_dashboard_path if current_farmer
    redirect_to admin_dashboard_path if current_admin
  end
end
