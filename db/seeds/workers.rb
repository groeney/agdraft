Worker.create(first_name: "Bob", last_name: "Smith", email: "worker@example.com", password: "password")
james = Worker.create(first_name: "James", last_name: "Example", email: "james@example.com", password: "password")
james.notifications << FactoryGirl.create_list(:notification, 10)

if @seed_search_data
  20.times do |n|
    image = File.new(Dir["seed_assets/headshots/*"].sample)
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories, :with_unavailabilities, :with_locations, profile_photo: image)
  end

  20.times do |n|
    image = File.new(Dir["seed_assets/headshots/*"].sample)
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories, profile_photo: image)
  end

  begin
    FactoryGirl.create_list(:worker, 10)
  rescue ActiveRecord::RecordInvalid
    puts "Failed to create workers (likely already created).".red
  end
end

