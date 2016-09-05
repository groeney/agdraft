FactoryGirl.define do
  factory :admin do
    sequence(:email){ |n| "admin-email-#{n}@example.com" }
    password "password"
  end
  factory :job_category do
    sequence(:title) { |n| "Category #{n}" }
  end

  factory :skill do
    sequence(:title) { |n| "Skill #{n}" }
  end

  factory :worker do
    first_name "Sally"
    last_name "Smith"
    sequence(:email){ |n| "worker-email-#{n}@example.com" }
    password "password"

    trait :with_job_categories do
      after(:create) do |worker|
        worker.job_categories << FactoryGirl.create_list(:job_category, 10)
      end
    end

    trait :with_skills do
      after(:create) do |worker|
        worker.skills << FactoryGirl.create_list(:skill, 10)
      end
    end
  end

  factory :farmer do
    first_name "Jon"
    last_name "Smith"
    sequence(:email){ |n| "farmer-email-#{n}@example.com" }
    password "password"
  end
end