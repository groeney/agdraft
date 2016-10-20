def create_workers(level, count = 1, verified = false)
  image = File.new(Dir["seed_assets/headshots/*"].sample)
  case level
  when 0
    FactoryGirl.create_list(:worker, count, verified: verified)
  when 1
    FactoryGirl.create_list(:worker, count, :with_skills, :with_job_categories, profile_photo: image, verified: verified)
  when 2
    FactoryGirl.create_list(:worker, count, :with_skills, :with_job_categories, :with_unavailabilities, :with_locations, profile_photo: image, verified: verified)
  else
    FactoryGirl.create_list(:worker, count, verified: verified)
  end
end