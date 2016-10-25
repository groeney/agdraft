class Farmers::ConfirmationsController < Devise::ConfirmationsController
  layout 'application'
  private
  def after_confirmation_path_for(resource_name, resource)
    root_path
  end
end