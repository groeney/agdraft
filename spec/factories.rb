FactoryGirl.define do
  factory :certificate do
    title { Faker::Lorem.word }
    issue_date { rand(4.years.ago..1.year.ago) }

    worker
  end

  factory :education do
    school { Faker::University.name }
    start_date { rand(4.years.ago..1.year.ago) }
    end_date { rand(start_date..Time.now) }

    worker
  end

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

  factory :job do
    farmer
    location
    title "MyString"
    description "MyText"
    accomodation_provided false
    business_name "MyString"
    business_description "MyText"
    pay_min "20"
    pay_max "25"
    start_date Date.today + 1.days
    end_date Date.today + 3.days
    number_of_workers "10-20"
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
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    nationality { Faker::Address.country }
    sequence(:email){ |n| "worker-email-#{n}@example.com" }
    password "password"

    trait :with_job_categories do
      transient do
        job_categories nil
      end

      after(:create) do |worker, evaluator|
        worker.job_categories << (evaluator.job_categories || JobCategory.all.sample(10) || FactoryGirl.create_list(:job_category, 10))
      end
    end

    trait :with_skills do
      transient do
        skills nil
      end

      after(:create) do |worker, evaluator|
        worker.skills << (evaluator.skills || Skill.all.sample(10) || FactoryGirl.create_list(:skill, 10))
      end
    end

    trait :with_locations do
      transient do
        locations nil
      end

      after(:create) do |worker, evaluator|
        worker.locations << (evaluator.locations || Location.all.sample(3) || FactoryGirl.create_list(:location, 3))
      end
    end

    trait :with_unavailabilities do
      transient do
        start_date nil
        end_date nil
      end

      after(:create) do |worker, evaluator|
        # Create a singluar unavailability or create multiple
        if (start_date = evaluator.start_date) && (end_date = evaluator.end_date)
          FactoryGirl.create(:unavailability, worker: worker, start_date: start_date, end_date: end_date)
        else
          5.times do
            FactoryGirl.create(:unavailability, worker: worker)
          end
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

    trait :with_certificates do
      after(:create) do |worker|
        5.times do
          FactoryGirl.create(:certificate, worker: worker)
        end
      end
    end

    trait :with_educations do
      after(:create) do |worker|
        5.times do
          FactoryGirl.create(:education, worker: worker)
        end
      end
    end
  end

  factory :farmer do
    first_name {  Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email){ |n| "farmer-email-#{n}@example.com" }
    password "password"
  end

  factory :location do
    state { Faker::Address.state }
    sequence(:region){ |n| "region-#{n}" }
  end
end
