FactoryGirl.define do
  # For factory :job see spec/factories/job.rb
  # For factory :worker see spec/factories/worker.rb

  factory :payment_audit do
    farmer
    job
    action "MyString"
    message "MyString"
    success false
  end

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

  factory :farmer do
    first_name {  Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email){ |n| "farmer-email-#{n}@example.com" }
    password "password"

    trait :with_locations do
      transient do
        location nil
      end

      after(:create) do |farmer, evaluator|
        farmer.location = evaluator.location || Location.all.try(:sample) || FactoryGirl.create(:location)
      end
    end
  end

  factory :location do
    state { Faker::Address.state }
    sequence(:region){ |n| "region-#{n}" }
  end
end
