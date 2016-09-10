require "rails_helper"

RSpec.describe Farmers::PaymentsController, type: :controller do
  describe "#update" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    let(:token) {"abc"}

    before do
      sign_in farmer
    end

    context "the farmer already has a stripe_customer_id" do
      before do
        farmer.update_attribute(:stripe_customer_id, "abc")
      end
       it "should update the customer with stripe" do
        expect(StripeService).to receive(:update_customer_source).with(farmer.id, token).and_return true
        put :update, token: token, format: :json
        expect(response.status).to eq 201
      end

      context "the stripe request fails" do
        it "should return a 400" do
          expect(StripeService).to receive(:update_customer_source).with(farmer.id, token).and_return false
          put :update, token: token, format: :json
          expect(response.status).to eq 400
        end
      end
    end

    context "the farmer does no have a stripe_customer_id" do
      it "should create a new customer record with stripe" do
        expect(StripeService).to receive(:create_customer).with(farmer.id, token).and_return true
        put :update, token: token, format: :json
        expect(response.status).to eq 201
      end

      context "the stripe request fails" do
        it "should return a 400" do
          expect(StripeService).to receive(:create_customer).with(farmer.id, token).and_return false
          put :update, token: token, format: :json
          expect(response.status).to eq 400 
        end
      end
    end
  end
end