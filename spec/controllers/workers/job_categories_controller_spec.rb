require "rails_helper"

RSpec.describe Workers::JobCategoriesController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:job_category) { FactoryGirl.create(:job_category) }

    before do
      sign_in worker
    end

    it "should create job_category for the worker" do
      post :create, job_category: { id: job_category.id }, format: :json

      expect(response.status).to eq(201)
      expect(worker.job_categories).to include job_category
    end

    it "should not create duplicate job_categories for the worker" do
      worker.job_categories << job_category
      post :create, job_category: { id: job_category.id }, format: :json

      expect(response.status).to eq(201)
      expect(worker.job_categories.where({id: job_category.id}).length).to eq 1
    end

    it "should respond with 404 invalid job_category" do
      post :create, job_category: { id: 0 }, format: :json
      expect(response.status).to eq(404)
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:job_category) { FactoryGirl.create(:job_category) }

    before do
      sign_in worker
      worker.job_categories << job_category
    end

    it "should delete workers' job_category" do
      delete :destroy, id: job_category.id, format: :json
      expect(response.status).to eq(204)
      worker.reload
      expect(worker.job_categories).not_to include job_category
    end

    it "should respond with 404 invalid job_category" do
      delete :destroy, id: 0, format: :json
      expect(response.status).to eq(404)
    end

    it "should respond with 404 worker doesn't have job_category" do
      new_job_category = FactoryGirl.create(:job_category)
      delete :destroy, id: new_job_category, format: :json
      expect(response.status).to eq(404)
    end
  end
end
