FactoryGirl.define do
  factory :job do
    farmer
    location
    title { Faker::Company.profession }
    description { Faker::Lorem.sentences(1) }
    accomodation_provided { Faker::Boolean.boolean }
    business_name { Faker::Company.name }
    business_description { Faker::Company.catch_phrase }
    pay_min { rand(10..20).to_s }
    pay_max { rand(20..30).to_s }
    start_date { 1.day.from_now }
    end_date { 3.days.from_now }
    number_of_workers { rand(1..5).to_s + "-" + rand(5..15).to_s }

    trait :with_job_categories do
      transient do
        job_categories nil
      end

      after(:create) do |job, evaluator|
        job.job_categories << (evaluator.job_categories || JobCategory.all.sample(2) || FactoryGirl.create_list(:job_category, 2))
      end
    end

    trait :with_skills do
      transient do
        skills nil
      end

      after(:create) do |job, evaluator|
        job.skills << (evaluator.skills || Skill.all.sample(3) || FactoryGirl.create_list(:skill, 3))
      end
    end
  end
end