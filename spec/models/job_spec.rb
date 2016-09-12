require 'rails_helper'

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
          expect(StripeService).to receive(:charge_job).with(job.id, JOB_PRICE).and_return true
        end
        it "sets job to published and returns true" do
          expect(job.publish).to eq true
          expect(job.published).to eq true
        end
      end

      context "stripe returns an error" do
        before do
          expect(StripeService).to receive(:charge_job).with(job.id, JOB_PRICE).and_return false
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
end
