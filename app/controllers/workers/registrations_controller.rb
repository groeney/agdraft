class Workers::RegistrationsController < Devise::RegistrationsController
  before_filter :dashboard_type, only: [:edit, :update]
  before_filter :nav_item, only: [:edit, :update]
  layout "dashboard", only: [:edit, :update]
  
  protected
  # The path used after sign up.
  def after_sign_up_path_for(resource)
    worker_onboard_job_categories_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    worker_onboard_job_categories_path
  end

  def dashboard_type
    @dashboard_type = "workers"
  end

  def nav_item
    @nav_item = "account_details"
  end
end
