require "rails_helper"

RSpec.describe Workers::LocationsController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:location) { FactoryGirl.create(:location) }

    before do
      sign_in worker
    end

    it "should create location for the worker" do
      post :create, id: location.id, format: :json

      expect(response.status).to eq(201)
      expect(worker.locations).to include location
    end

    it "should not create duplicate job_categories for the worker" do
      worker.locations << location
      post :create, id: location.id, format: :json

      expect(response.status).to eq(201)
      expect(worker.locations.where({id: location.id}).length).to eq 1
    end

    it "should respond with 404 invalid location" do
      post :create, location: { id: 0 }, format: :json
      expect(response.status).to eq(404)
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:location) { FactoryGirl.create(:location) }

    before do
      sign_in worker
      worker.locations << location
    end

    it "should delete workers' location" do
      delete :destroy, id: location.id, format: :json
      expect(response.status).to eq(204)
      worker.reload
      expect(worker.locations).not_to include location
    end

    it "should respond with 404 invalid location" do
      delete :destroy, id: 0, format: :json
      expect(response.status).to eq(404)
    end

    it "should respond with 404 worker doesn't have location" do
      new_location = FactoryGirl.create(:location)
      delete :destroy, id: new_location.id, format: :json
      expect(response.status).to eq(404)
    end
  end
end