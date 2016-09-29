require "csv"
require "open-uri"

filename = "./db/seeds/data/user_migration_data.csv"
CSV.foreach(filename, :headers => true) do |row|
  resource = row.to_hash.symbolize_keys
  display_name = resource.delete(:display_name).split(" ")

  resource[:first_name] = display_name.first
  resource[:last_name] = display_name.length > 1 ? display_name.last : ""
  resource[:migrated] = true

  if (profile_pic = resource.delete(:profile_pic))
    profile_pic_object = open(profile_pic)
  end

  location_string = resource.delete(:location)
  location = Location.find_by(state: location_string.split(", ").last, region: location_string.split(", ").first)
  worker = Worker.invite!(resource) do |u|
    u.skip_invitation = true
  end

  worker.update_attributes(profile_photo: profile_pic_object)
  if location
    worker.locations << location
  end
end