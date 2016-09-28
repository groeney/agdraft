begin
  20.times do |n|
    image = File.new(Dir["seed_assets/headshots/*"].sample)
    FactoryGirl.create(:farmer, location: Location.all.sample, profile_photo: image)
  end
rescue ActiveRecord::RecordInvalid
  puts "Failed to create farmers (likely already created).".red
end

Farmer.create(first_name: "Joe", last_name: "Blogs", email: "farmer@example.com", password: "password")
