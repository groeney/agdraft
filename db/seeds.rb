# Seed data for all environments
require_relative "./seeds/locations"
require_relative "./seeds/job_categories"
require_relative "./seeds/skills"

case Rails.env
when "development" || "test" || "staging"
  require_relative "./seeds/admins"
  require_relative "./seeds/workers"
  require_relative "./seeds/farmers"
when "production"
  # Add production specific seeds
end