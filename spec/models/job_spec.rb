require "rails_helper"

RSpec.describe Job, type: :model do
  it { is_expected.to validate_presence_of :title }

  describe "#publish" do
    let(:job) {FactoryGirl.create(:job)}
    let(:amount) {"200"}
    context "when the farmer has_valid_payment?" do
      before do
        expect_any_instance_of(Farmer).to receive(:has_valid_payment?).and_return true
      end
      context "stripe successfully charges the user" do
        before do
          expect(StripeService).to receive(:charge_job).with(job.id, JOB_PRICE * 100).and_return true
        end
        it "sets job to published and returns true" do
          expect(job.publish).to eq true
          expect(job.published).to eq true
        end
      end

      context "stripe returns an error" do
        before do
          expect(StripeService).to receive(:charge_job).with(job.id, JOB_PRICE * 100).and_return false
        end
        it "does not set job to published and returns false" do
          expect(job.publish).to eq false
          expect(job.published).to eq false
        end
      end
    end

    context "when the farmer does not has_valid_payment?" do
      before do
        expect_any_instance_of(Farmer).to receive(:has_valid_payment?).and_return false
      end
      it "does not set published and returns false" do
        expect(job.publish).to eq false
        expect(job.published).to eq false
      end
    end

    context "when the farmer has credit" do
      it "charges the farmer the correct amount" do
        expect_any_instance_of(Farmer).to receive(:has_valid_payment?).and_return true
        credit = JOB_PRICE / 2
        job.farmer.update_attribute(:credit, credit)
        expect(StripeService).to receive(:charge_job).with(job.id, (JOB_PRICE - credit)*100).and_return true
        
        job.publish
        
        expect(job.farmer.reload.credit).to eq (0)
        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq job.farmer.id
        expect(pa.job_id).to eq job.id
        expect(pa.action).to eq "Credit Applied"
        expect(pa.success).to eq true
        expect(pa.amount).to eq JOB_PRICE/2
      end
      it "does not charge when enough credit to cover entire payment" do
        credit = JOB_PRICE * 2
        job.farmer.update_attribute(:credit, credit)
        expect(StripeService).to_not receive(:charge_job)
        
        job.publish
        
        expect(job.farmer.reload.credit).to eq JOB_PRICE
        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq job.farmer.id
        expect(pa.job_id).to eq job.id
        expect(pa.action).to eq "Credit Applied"
        expect(pa.success).to eq true
        expect(pa.amount).to eq JOB_PRICE
      end
      it "does not charge when credit is exact price of job" do
        job.farmer.update_attribute(:credit, JOB_PRICE)
        expect(StripeService).to_not receive(:charge_job)
        
        job.publish
        
        expect(job.farmer.reload.credit).to eq 0
        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq job.farmer.id
        expect(pa.job_id).to eq job.id
        expect(pa.action).to eq "Credit Applied"
        expect(pa.success).to eq true
        expect(pa.amount).to eq JOB_PRICE
      end
    end

    context "when the job is published" do
      before do
        job.update_attribute(:published, true)
      end
      it "should not attempt a stripe charge" do
        expect(StripeService).to_not receive(:charge_job)
        expect(job.publish).to eq true
      end
    end
  end

  # Job scope :skills
  describe "#skills" do
    let!(:jobs_without_skills) { FactoryGirl.create_list(:job, 20) }
    context "jobs with a particular skill" do
      let(:skill) { FactoryGirl.create(:skill) }
      let!(:jobs_with_skill) { FactoryGirl.create_list(:job, 10, skills: [skill]) }

      it "should return correct number of jobs" do
        results = Job.skills(skill.id)
        expect(results.count).to eq(jobs_with_skill.count)
      end

      it "should return all correct jobs" do
        results = Job.skills(skill.id)
        jobs_with_skill.each do |job|
          expect(results).to include job
        end
      end

      it "should return only correct jobs" do
        results = Job.skills(skill.id)
        results.each do |job|
          expect(jobs_with_skill).to include job
        end
      end
    end
  end

  # Job scope :job_categories
  describe "#job_categories" do
    let!(:jobs_without_job_categories) { FactoryGirl.create_list(:job, 20) }
    context "users with a particular job_category" do
      let(:job_category) { FactoryGirl.create(:job_category) }
      let!(:jobs_with_job_category) { FactoryGirl.create_list(:job, 10, job_categories: [job_category]) }

      it "should return correct number of jobs" do
        results = Job.job_categories(job_category.id)
        expect(results.count).to eq(jobs_with_job_category.count)
      end

      it "should return all correct jobs" do
        results = Job.job_categories(job_category.id)
        jobs_with_job_category.each do |job|
          expect(results).to include job
        end
      end

      it "should return only correct jobs" do
        results = Job.job_categories(job_category.id)
        results.each do |job|
          expect(jobs_with_job_category).to include job
        end
      end
    end
  end

  # Job scope :locations
  describe "#locations" do
    let!(:jobs_without_locations) { FactoryGirl.create_list(:job, 20) }
    context "users with a particular location" do
      let(:location) { FactoryGirl.create(:location) }
      let!(:jobs_with_location) { FactoryGirl.create_list(:job, 10, location: location) }

      it "should return correct number of jobs" do
        results = Job.locations(location.id)
        expect(results.count).to eq(jobs_with_location.count)
      end

      it "should return all correct jobs" do
        results = Job.locations(location.id)
        jobs_with_location.each do |job|
          expect(results).to include job
        end
      end

      it "should return only correct jobs" do
        results = Job.locations(location.id)
        results.each do |job|
          expect(jobs_with_location).to include job
        end
      end
    end
  end

  # Job scope :date_range
  describe "#date_range" do
    let(:initial_start_date) { 10.days.from_now }
    let(:initial_end_date) { 30.days.from_now }
    let!(:initial_jobs) { FactoryGirl.create_list(:job, 10, start_date: initial_start_date, end_date: initial_end_date) }

    context "jobs in particular date range" do
      let(:start_date) { initial_start_date + 30.days }
      let(:end_date) { initial_end_date + 60.days }
      let!(:jobs) { FactoryGirl.create_list(:job, 10, start_date: start_date, end_date: end_date) }

      it "should return correct number of jobs" do
        results = Job.date_range(start_date, end_date)
        expect(results.count).to eq(jobs.count)
      end

      it "should return all correct jobs" do
        results = Job.date_range(start_date, end_date)
        jobs.each do |job|
          expect(results).to include job
        end
      end

      it "should return only correct jobs" do
        results = Job.date_range(start_date, end_date)
        results.each do |job|
          expect(jobs).to include job
        end
      end
    end
  end

  describe ".filter_rating" do
    let(:job_categories) { FactoryGirl.create_list(:job_category, 10) }
    let(:skills) { FactoryGirl.create_list(:skill, 10) }
    let(:locations) { FactoryGirl.create_list(:location, 3) }
    let(:location) { locations.first }
    let(:filter_params) { { job_categories: job_categories.map(&:id), skills: skills.map(&:id), locations: locations.map(&:id) } }

    context "job with no attributes" do
      let(:job) { FactoryGirl.create(:job) }

      it "should return a rating of 0" do
        expect(job.filter_rating(filter_params)).to eq(0)
      end
    end

    context "job with only our job_categories" do
      let(:job) { FactoryGirl.create(:job, job_categories: job_categories) }

      it "should return correct value" do
        expect(job.filter_rating(filter_params)).to eq(job_categories.count)
      end
    end

    context "job with only our skills" do
      let(:job) { FactoryGirl.create(:job, skills: skills) }

      it "should return correct value" do
        expect(job.filter_rating(filter_params)).to eq(skills.count)
      end
    end

    context "job with one of our locations and nothing else" do
      let(:job) { FactoryGirl.create(:job, location: location) }

      it "should return correct value" do
        expect(job.filter_rating(filter_params)).to eq(1)
      end
    end

    context "job with all of our attributes" do
      let(:job) { FactoryGirl.create(:job, job_categories: job_categories, skills: skills, location: location) }

      it "should return correct value" do
        correct_value = job_categories.count + skills.count + 1
        expect(job.filter_rating(filter_params)).to eq(correct_value)
      end
    end

    context "job with attributes but none of ours" do
      let(:new_job_categories) { FactoryGirl.create_list(:job_category, 10) }
      let(:new_skills) { FactoryGirl.create_list(:skill, 10) }
      let(:new_location) { FactoryGirl.create(:location) }
      let(:job) { FactoryGirl.create(:job, job_categories: new_job_categories, skills: new_skills, location: new_location) }

      it "should return correct value" do
        expect(job.filter_rating(filter_params)).to eq(0)
      end
    end
  end
end
