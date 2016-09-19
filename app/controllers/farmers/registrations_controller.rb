class Farmers::RegistrationsController < Devise::RegistrationsController
  before_filter :dashboard_type, only: [:edit, :update]
  before_filter :nav_item, only: [:edit, :update]
  layout :determine_layout

  def new
    build_resource({})
    yield resource if block_given?
    respond_with resource
  end

  protected

  # cannot specify two different 'layout' options at the top of the controller 
  # hence needing to use this method to determine appropriate layout
  def determine_layout
    case action_name
    when "new"
      "hero"
    when "create"
      "hero"
    when "edit"
      "dashboard"
    when "update"
      "dashboard"
    end
  end

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
