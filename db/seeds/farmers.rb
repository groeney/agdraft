begin
  20.times do |n|
    FactoryGirl.create(:farmer, location: Location.all.sample)
  end
rescue ActiveRecord::RecordInvalid
  puts "Failed to create farmers (likely already created).".red
end

Farmer.create(first_name: "Joe", last_name: "Blogs", email: "farmer@example.com", password: "password")
