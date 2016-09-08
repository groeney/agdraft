require "rails_helper"

RSpec.describe Farmers::LocationsController, type: :controller do
  describe "#update" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    let(:location) { FactoryGirl.create(:location) }

    before do
      sign_in farmer
    end

    it "should update the farmers location" do
      put :update, id: location.id, format: :json

      expect(response.status).to eq(201)
      expect(farmer.reload.location).to eq location
    end

    it "should respond with 404 invalid location" do
      put :update, id: 0, format: :json
      expect(response.status).to eq(404)
    end
  end
end