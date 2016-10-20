class Farmer::ParameterSanitizer < Devise::ParameterSanitizer
  def initialize(*)
    super
    permit(:sign_up, keys: [:first_name, :last_name, :referred_by_token, :business_name, :location_id, :contact_number])
  end
end