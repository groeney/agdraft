unless (num_skills = Skill.count) > 0
  require_relative "./skills"
end

num_job_categories = (num_skills/5)

num_job_categories.times do |n|
  job_category = JobCategory.create(title: "Category #{n}")
  5.times do |m|
    job_category.skills << Skill.all.sample
  end
end
