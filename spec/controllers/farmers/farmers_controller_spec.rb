require "rails_helper"

RSpec.describe Farmers::FarmersController, type: :controller do
  describe "#update" do
    let(:farmer) { FactoryGirl.create(:farmer) }

    before do
      sign_in farmer
    end

    it "should update the farmer" do
      params = {
        business_name: "123",
        business_description: "foobarban",
        contact_name: "Joe Bloe",
        contact_number: "1231231234"
      }

      put :update, id: farmer.id, farmer: params, format: :json

      expect(response.status).to eq(204)
      expect(farmer.reload.business_name).to eq params[:business_name]
      expect(farmer.reload.business_description).to eq params[:business_description]
      expect(farmer.reload.contact_name).to eq params[:contact_name]
      expect(farmer.reload.contact_number).to eq params[:contact_number]
    end

    it "should respond with 400 on invalid update" do
      put :update, id: farmer.id, format: :json
      expect(response.status).to eq(400)
    end
  end
end