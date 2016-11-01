include ActionDispatch::TestProcess # For image upload helpers
FactoryGirl.define do
  factory :worker do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    nationality { Faker::Address.country }
    description { Faker::Lorem.paragraph }
    sequence(:email){ |n| "worker-email-#{SecureRandom.hex(3)}@example.com" }
    profile_photo { fixture_file_upload(File.new(Dir["seed_assets/headshots/*"].sample), "image/jpg") }
    password "password"

    trait :with_job_categories do
      transient do
        job_categories nil
      end

      after(:create) do |worker, evaluator|
        num = rand(1..4)
        worker.job_categories << (evaluator.job_categories || JobCategory.all.sample(num) || FactoryGirl.create_list(:job_category, num))
      end
    end

    trait :with_skills do
      transient do
        skills nil
      end

      after(:create) do |worker, evaluator|
        num = rand(3..15)
        worker.skills << (evaluator.skills || Skill.all.sample(num) || FactoryGirl.create_list(:skill, num))
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

    trait :with_notifications do
      after(:create) do |worker|
        worker.notifications << FactoryGirl.create_list(:notification, 5)
      end
    end

    trait :with_reviews do
      after(:create) do |worker|
        farmers = FactoryGirl.create_list(:farmer, 10)
        farmers.each do |farmer|
          job = FactoryGirl.create(:job, farmer: farmer, published: true)
          job_worker = FactoryGirl.create(:job_worker, job_id: job.id, worker: worker)
          job_worker.hire!
          worker.reload
          if rand(2) > 0
            FactoryGirl.create(:review, reviewer: farmer, reviewee: worker)
          else
            FactoryGirl.create(:review, reviewer: worker, reviewee: farmer)
          end
        end

      end
    end
  end
end