class PagesController < ApplicationController
  layout "hero"

  def home
    @workers = Worker.visibles.sample(8)
    @jobs = Job.visibles.sample(8)
    return redirect_to worker_dashboard_path if current_worker
    return redirect_to farmer_dashboard_path if current_farmer
    return redirect_to admin_dashboard_path if current_admin
  end

  def get_started
  end

  def login
  end

  def letsencrypt
    render text: "a4S9VajFQYWYEKOdssAWwVji8MV73ghmDBh38U7ZyfU.wqnXpAe_Kqdnb_YmSuZyX3mJtyGs0KUUooA7YaRc378"
  end
end
