FactoryGirl.define do
  factory :admin do
    sequence(:email){ |n| "email-#{n}@example.com" }
    password "password"    
  end
  factory :job_category do
    sequence(:url) { |n| "Category_#{n}" }
  end

  factory :skill do
    sequence(:url) { |n| "Skill_#{n}" }
  end

  factory :worker do
    first_name "Sally"
    last_name "Smith"
    sequence(:email){ |n| "email-#{n}@example.com" }
    password "password"
  end

  factory :farmer do
    first_name "Jon"
    last_name "Smith"
    sequence(:email){ |n| "email-#{n}@example.com" }
    password "password"
  end
end