# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
NUM_SKILLS = 50
NUM_JOB_CATEGORIES = (NUM_SKILLS/5)

NUM_SKILLS.times do |n|
  Skill.create(title: "Skill #{n}")
end

NUM_JOB_CATEGORIES.times do |n|
  job_category = JobCategory.create(title: "Category #{n}")
  5.times do |m|
    job_category.skills << Skill.all.sample
  end
end

Admin.create(email: "admin@agdraft.com.au", password: "password")
Worker.create(first_name: "Bob", last_name: "Smith", email: "worker@example.com", password: "password")
Farmer.create(first_name: "Joe", last_name: "Blogs", email: "farmer@example.com", password: "password")