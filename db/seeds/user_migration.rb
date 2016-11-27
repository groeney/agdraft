require "csv"
require "open-uri"

filename = "./db/seeds/data/user_migration_data.csv"
CSV.foreach(filename, :headers => true) do |row|
  resource = row.to_hash.symbolize_keys
  display_name = resource.delete(:display_name).split(" ")
  user_type = resource.delete(:user_type)
  profile_photo = resource.delete(:profile_photo)

  resource[:first_name] = display_name.first
  resource[:last_name] = display_name.length > 1 ? display_name.last : ""
  resource[:migrated] = true

  location_string = resource.delete(:location)
  location = Location.find_by(state: location_string.split(", ").last, region: location_string.split(", ").first)

  case user_type
  when "worker"
    resource_model = Worker.invite!(resource) do |u|
      u.skip_invitation = true
    end
    resource_model.locations << location if location
  when "farmer"
    resource_model = Farmer.invite!(resource) do |u|
      u.skip_invitation = true
    end
    resource_model.update_attributes location: location if location
  when "other"
    puts "Not creating user because user_type 'other'."
    next
  else
    puts "Not creating user because no user_type provided."
    next
  end

  unless profile_photo == "NULL"
    resource_model.update_attributes profile_photo: profile_photo
  end
end