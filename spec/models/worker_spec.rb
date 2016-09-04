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
end
