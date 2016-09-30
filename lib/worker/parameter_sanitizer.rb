class Worker::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:first_name, :last_name, :referred_by_token, :mobile_number])
    permit(:account_update, keys: [:first_name, :last_name, :mobile_number])
  end
end