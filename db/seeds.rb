# Seed data for all environments
require_relative "./seeds/skills"
require_relative "./seeds/job_categories"
require_relative "./seeds/locations"

case Rails.env
when "development" || "test"
  require_relative "./seeds/admins"
  require_relative "./seeds/workers"
  require_relative "./seeds/farmers"
when "staging"
  require_relative "./seeds/admins"
  require_relative "./seeds/workers"
  require_relative "./seeds/farmers"
when "production"
  # Add production specific seeds
end