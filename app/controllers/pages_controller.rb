class PagesController < ApplicationController
  layout "hero"

  def home
    @workers = Worker.all.sample(8)
    @jobs = Job.all.sample(8)
    return redirect_to worker_dashboard_path if current_worker
    return redirect_to farmer_dashboard_path if current_farmer
    return redirect_to admin_dashboard_path if current_admin
  end

  def get_started
  end

  def login
  end
end
