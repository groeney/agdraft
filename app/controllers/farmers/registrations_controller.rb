class Farmers::RegistrationsController < Devise::RegistrationsController
  before_filter :dashboard_type, only: [:edit, :update]
  before_filter :nav_item, only: [:edit, :update]
  layout "dashboard", only: [:edit, :update]

  protected

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    farmer_dashboard_path
  end

  def dashboard_type
    @dashboard_type = "farmers"
  end

  def nav_item
    @nav_item = "account_details"
  end
end
