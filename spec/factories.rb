FactoryGirl.define do
  factory :previous_employer do
    business_name { Faker::Company.name }
    contact_name { Faker::Name.name }
    contact_email { Faker::Internet.email }
    contact_phone { Faker::PhoneNumber.phone_number }

    job_title { Faker::Name.title }
    job_description { Faker::Lorem.paragraph }
    start_date { rand(4.years.ago..1.year.ago) }
    end_date { rand(start_date..Time.now) }

    worker
  end

  factory :unavailability do
    start_date { Time.now }
    end_date { rand(100.days).seconds.from_now }
    worker
  end

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

    trait :with_unavailabilities do
      after(:create) do |worker|
        5.times do
          FactoryGirl.create(:unavailability, worker: worker)
        end
      end
    end

    trait :with_previous_employers do
      after(:create) do |worker|
        5.times do
          FactoryGirl.create(:previous_employer, worker: worker)
        end
      end
    end

    trait :with_previous_employers do
      after(:create) do |worker|
        5.times do
          FactoryGirl.create(:previous_employer, worker: worker)
        end
      end
    end

  end

  factory :farmer do
    first_name "Jon"
    last_name "Smith"
    sequence(:email){ |n| "farmer-email-#{n}@example.com" }
    password "password"
  end

  factory :location do
    state "QLD"
    sequence(:region){ |n| "region-#{n}" }
  end
end
