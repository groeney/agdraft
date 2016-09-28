require "csv"
filename = "./db/seeds/data/skills.csv"
CSV.foreach(filename, :headers => true) do |row|
  skill_obj = row.to_hash.symbolize_keys!
  skill = Skill.find_or_create_by(title: skill_obj[:title])
  job_category = JobCategory.find_by(title: skill_obj[:job_category])
  job_category.skills << skill if job_category
end
