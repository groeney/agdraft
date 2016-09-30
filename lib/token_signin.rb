module TokenSignin
  def token_signin(resource)
    resource_name = resource.class.to_s.downcase
    return "?#{resource_name}_email=#{resource.email}&#{resource_name}_token=#{resource.authentication_token}"
  end
end