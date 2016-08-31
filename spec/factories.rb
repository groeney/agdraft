FactoryGirl.define do
  factory :job_category do
    sequence(:url) { |n| "Category_#{n}" }
  end

  factory :skill do
    sequence(:url) { |n| "Skill_#{n}" }
  end

  factory :worker_user do

  end
end