Farmer.create(first_name: "Joe", last_name: "Blogs", email: "farmer@example.com", password: "password")
bill = Farmer.create(first_name: "Bill", last_name: "Example", email: "bill@example.com", password: "password")
bill.notifications << FactoryGirl.create_list(:notification, 10)

begin
  20.times do |n|
    image = File.new(Dir["seed_assets/headshots/*"].sample)
    FactoryGirl.create(:farmer, location: Location.all.sample, profile_photo: image)
  end
rescue ActiveRecord::RecordInvalid
  puts "Failed to create farmers (likely already created).".red
end