if Rails.env.development?
  Rails.application.config.admin_email = "example@foo.com"
elsif Rails.env.staging?
  Rails.application.config.admin_email = "xander.groeneveld@gmail.com"
elsif Rails.env.production?
  Rails.application.config.admin_email = "web_admin@agdraft.com.au"
end