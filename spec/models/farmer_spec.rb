require "rails_helper"

RSpec.describe Farmer, type: :model do
  describe "#set_referral_user" do
    let(:referral_user){ FactoryGirl.create(:farmer) }

    context "when a valid referral token is provided" do
      it "links the referral user" do
        farmer = FactoryGirl.create(:farmer, {referred_by_token: referral_user.referral_token})
        expect(farmer.referral_user.id).to eq(referral_user.id)
      end
    end
    context "when an invalid referral token is provided" do
      it "does not link a referral user" do
        farmer = FactoryGirl.create(:farmer, {referred_by_token: "acvs"})
        expect(farmer.referral_user).to eq(nil)
      end
    end
  end

  describe "#has_valid_payment?" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    context "when a farmer has a stripe customer id" do
      before do 
        farmer.update_attribute(:stripe_customer_id, "foo")
      end
      context "when a customer is deliquent" do
        before do
          farmer.update_attribute(:stripe_delinquent, true)
        end
        it "should return false" do
          expect(farmer.has_valid_payment?).to eq false
        end
      end
      context "when a customer is not deliquent" do
        before do
          farmer.update_attribute(:stripe_delinquent, false)
        end
        it "should return true" do
          expect(farmer.has_valid_payment?).to eq true
        end
      end
    end

    context "when a farmer does not have a stripe customer id" do
      it "should return false" do
        expect(farmer.has_valid_payment?).to eq false
      end
    end
  end

  describe "validations" do
    it "validates credit to be a positive value" do
      farmer = FactoryGirl.create(:farmer)
      farmer.credit = -100
      expect(farmer.valid?).to eq false
    end
  end

  describe "#jobs_for_worker" do
    let(:farmer){ FactoryGirl.create(:farmer, :with_job) }
    context "when farmer has published jobs" do
      before do
        farmer.jobs.first.update_attribute(:published, true)
      end
      context "and worker has been added to job" do
        before do
          @worker = FactoryGirl.create(:worker)
          JobWorker.create(worker_id: @worker.id, job_id: farmer.jobs.first.id, state: "interested")
        end

        it "returns the job with invited true" do
          jobs = farmer.jobs_for_worker(@worker.id)
          expect(jobs.is_a? Array).to eq true
          expect(jobs.first[:job]).to eq farmer.jobs.first
          expect(jobs.first[:invited]).to eq true
        end
      end
      context "and worker has not been added to any jobs" do
        it "returns the job with invited false" do
          jobs = farmer.jobs_for_worker(FactoryGirl.create(:worker).id)
          expect(jobs.is_a? Array).to eq true
          expect(jobs.first[:job]).to eq farmer.jobs.first
          expect(jobs.first[:invited]).to eq false
        end
      end
    end
    context "when farmer has no published jobs" do
      it "returns an empty array" do
        expect(farmer.jobs_for_worker(FactoryGirl.create(:worker).id)).to eq []
      end
    end
  end
end
