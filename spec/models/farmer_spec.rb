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
end
