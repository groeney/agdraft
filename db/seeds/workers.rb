Worker.create(first_name: "Bob", last_name: "Smith", email: "worker@example.com", password: "password")

if @seed_search_data
  20.times do |n|
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories, :with_unavailabilities)
    worker.locations << Location.all.sample(3)
  end

  20.times do |n|
    worker = FactoryGirl.create(:worker, :with_skills, :with_job_categories)
    worker.locations << Location.all.sample(1)
  end

  FactoryGirl.create_list(:worker, 10)
end

