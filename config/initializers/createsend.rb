config_yaml = File.read(Rails.root.join('config/createsend.yml'))
config_hash = YAML.load(ERB.new(config_yaml).result).symbolize_keys
Rails.application.config.smart_email_ids = config_hash
Rails.application.config.campaign_monitor_api_key = ENV["CAMPAIGN_MONITOR_API_KEY"]