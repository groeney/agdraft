def create_workers(level, count = 1)
  image = File.new(Dir["seed_assets/headshots/*"].sample)
  case level
  when 0
    FactoryGirl.create_list(:worker, count)
  when 1
    FactoryGirl.create_list(:worker, count, :with_skills, :with_job_categories, profile_photo: image)
  when 2
    FactoryGirl.create_list(:worker, count, :with_skills, :with_job_categories, :with_unavailabilities, :with_locations, profile_photo: image)
  else
    FactoryGirl.create_list(:worker, count)
  end
end