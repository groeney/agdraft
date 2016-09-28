require "open-uri"
require "csv"
filename = "./db/seeds/data/job_categories.csv"
CSV.foreach(filename, :headers => true) do |row|
  job_category_obj = row.to_hash.symbolize_keys!
  job_category = JobCategory.create(title: job_category_obj[:title])
  image_obj = open("./app/assets/images/job_category_images/#{job_category_obj[:image]}")
  job_category.update_attributes(image: image_obj)
end