Worker.create(first_name: "Bob", last_name: "Smith", email: "worker@example.com", password: "password")

if @seed_search_data
  20.times do |n|
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories, :with_unavailabilities, :with_locations)
  end

  20.times do |n|
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories)
  end

    FactoryGirl.create_list(:worker, 10)
  rescue ActiveRecord::RecordInvalid
    puts "Failed to create workers (likely already created).".red
  end
end

