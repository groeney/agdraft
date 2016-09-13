if @seed_search_data
  require_relative "./farmers" unless Farmer.all.count > 10
  50.times do |n|
    FactoryGirl.create(:job, :with_job_categories, farmer: Farmer.all.sample, location: Location.all.sample)
  end
end