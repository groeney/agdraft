if @seed_search_data
  require_relative "./farmers" unless Farmer.all.count > 10
  50.times do |n|
    start_date = rand(1..365).days.from_now.round
    end_date = start_date + rand(3..60).days
    FactoryGirl.create(:job, :with_job_categories, farmer: Farmer.all.sample, location: Location.all.sample, start_date: start_date, end_date: end_date)
  end
end