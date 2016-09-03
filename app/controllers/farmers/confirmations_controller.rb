class Farmers::ConfirmationsController < Devise::ConfirmationsController
  private
  def after_confirmation_path_for(resource_name, resource)
    farmer_dashboard_path
  end
end