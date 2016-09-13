require "rails_helper"

RSpec.describe Worker, type: :model do
  describe "#set_referral_user" do
    let(:referral_user){ FactoryGirl.create(:farmer) }

    context "when a valid referral token is provided" do
      it "links the referral user" do
        worker = FactoryGirl.create(:worker, {referred_by_token: referral_user.referral_token})
        expect(worker.referral_user.id).to eq(referral_user.id)
      end
    end
    context "when an invalid referral token is provided" do
      it "does not link a referral user" do
        worker = FactoryGirl.create(:worker, {referred_by_token: "acvs"})
        expect(worker.referral_user).to eq(nil)
      end
    end
  end

  # Worker scope :skills
  describe "#skills" do
    let!(:workers_without_skills) { FactoryGirl.create_list(:worker, 20) }
    context "users with a particular skill" do
      let(:skill) { FactoryGirl.create(:skill) }
      let!(:workers_with_skill) { FactoryGirl.create_list(:worker, 10, skills: [skill]) }

      it "should return correct number of workers" do
        results = Worker.skills(skill.id)
        expect(results.count).to eq(workers_with_skill.count)
      end

      it "should return all correct workers" do
        results = Worker.skills(skill.id)
        workers_with_skill.each do |worker|
          expect(results).to include worker
        end
      end

      it "should return only correct workers" do
        results = Worker.skills(skill.id)
        results.each do |worker|
          expect(workers_with_skill).to include worker
        end
      end
    end
  end

  # Worker scope :job_categories
  describe "#job_categories" do
    let!(:workers_without_job_categories) { FactoryGirl.create_list(:worker, 20) }
    context "users with a particular job_category" do
      let(:job_category) { FactoryGirl.create(:job_category) }
      let!(:workers_with_job_category) { FactoryGirl.create_list(:worker, 10, job_categories: [job_category]) }

      it "should return correct number of workers" do
        results = Worker.job_categories(job_category.id)
        expect(results.count).to eq(workers_with_job_category.count)
      end

      it "should return all correct workers" do
        results = Worker.job_categories(job_category.id)
        workers_with_job_category.each do |worker|
          expect(results).to include worker
        end
      end

      it "should return only correct workers" do
        results = Worker.job_categories(job_category.id)
        results.each do |worker|
          expect(workers_with_job_category).to include worker
        end
      end
    end
  end

  # Worker scope :locations
  describe "#locations" do
    let!(:workers_without_locations) { FactoryGirl.create_list(:worker, 20) }
    context "users with a particular location" do
      let(:location) { FactoryGirl.create(:location) }
      let!(:workers_with_location) { FactoryGirl.create_list(:worker, 10, locations: [location]) }

      it "should return correct number of workers" do
        results = Worker.locations(location.id)
        expect(results.count).to eq(workers_with_location.count)
      end

      it "should return all correct workers" do
        results = Worker.locations(location.id)
        workers_with_location.each do |worker|
          expect(results).to include worker
        end
      end

      it "should return only correct workers" do
        results = Worker.locations(location.id)
        results.each do |worker|
          expect(workers_with_location).to include worker
        end
      end
    end
  end

  # Worker scope :availability
  describe "#availability" do
    let!(:available_workers) { FactoryGirl.create_list(:worker, 20) }
    context "some users unavailable on particular dates" do
      let(:start_date) { 10.days.from_now }
      let(:end_date) { 30.days.from_now }
      let!(:unavailable_workers) { FactoryGirl.create_list(:worker, 10, :with_unavailabilities, start_date: start_date, end_date: end_date) }

      it "should return correct number of workers" do
        results = Worker.availability(start_date, end_date)
        expect(results.count).to eq(available_workers.count)
      end

      it "should return all correct workers" do
        results = Worker.availability(start_date, end_date)
        available_workers.each do |worker|
          expect(results).to include worker
        end
      end

      it "should return only correct workers" do
        results = Worker.availability(start_date, end_date)
        results.each do |worker|
          expect(available_workers).to include worker
        end
      end
    end
  end

  describe ".filter_rating" do
    let(:job_categories) { FactoryGirl.create_list(:job_category, 10) }
    let(:skills) { FactoryGirl.create_list(:skill, 10) }
    let(:locations) { FactoryGirl.create_list(:location, 3) }
    let(:filter_params) { { job_categories: job_categories.map(&:id), skills: skills.map(&:id), locations: locations.map(&:id) } }

    context "worker with no attributes" do
      let(:worker) { FactoryGirl.create(:worker) }

      it "should return a rating of 0" do
        expect(worker.filter_rating(filter_params)).to eq(0)
      end
    end

    context "worker with only our job_categories" do
      let(:worker) { FactoryGirl.create(:worker, job_categories: job_categories) }

      it "should return correct value" do
        expect(worker.filter_rating(filter_params)).to eq(job_categories.count)
      end
    end

    context "worker with only our skills" do
      let(:worker) { FactoryGirl.create(:worker, skills: skills) }

      it "should return correct value" do
        expect(worker.filter_rating(filter_params)).to eq(skills.count)
      end
    end

    context "worker with only our locations" do
      let(:worker) { FactoryGirl.create(:worker, locations: locations) }

      it "should return correct value" do
        expect(worker.filter_rating(filter_params)).to eq(locations.count)
      end
    end

    context "worker with all our attributes" do
      let(:worker) { FactoryGirl.create(:worker, job_categories: job_categories, skills: skills, locations: locations) }

      it "should return correct value" do
        correct_value = job_categories.count + skills.count + locations.count
        expect(worker.filter_rating(filter_params)).to eq(correct_value)
      end
    end

    context "worker with attributes but none of ours" do
      let(:new_job_categories) { FactoryGirl.create_list(:job_category, 10) }
      let(:new_skills) { FactoryGirl.create_list(:skill, 10) }
      let(:new_locations) { FactoryGirl.create_list(:location, 3) }
      let(:worker) { FactoryGirl.create(:worker, job_categories: new_job_categories, skills: new_skills, locations: new_locations) }

      it "should return correct value" do
        expect(worker.filter_rating(filter_params)).to eq(0)
      end
    end
  end
end
