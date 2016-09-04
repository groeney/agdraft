class Workers::RegistrationsController < Devise::RegistrationsController
  # The path used after sign up.
  def after_sign_up_path_for(resource)
    job_categories_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    job_categories_path
  end
end
