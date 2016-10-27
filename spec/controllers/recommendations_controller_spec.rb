require "rails_helper"

RSpec.describe RecommendationsController, type: :controller do
  describe "#block_job" do
    let(:worker) { FactoryGirl.create(:worker, :with_job_categories, :with_skills) }
    before do
      sign_in worker
      FactoryGirl.create_list(:job, 10, :with_job_categories, :with_skills, job_categories: worker.job_categories.sample, skills: worker.skills.sample)
    end
    it "should not recommend blocked recommendation" do
      recommendation = worker.job_recommendations.first
      put :block_job, id: recommendation.id, format: :json
      expect(worker.job_recommendations.map { |r| r.id }).not_to include recommendation.id
    end

    it "all recommendations should be unique after blocking" do
      recommendation = worker.job_recommendations.first
      put :block_job, id: recommendation.id, format: :json
      rec_ids = worker.job_recommendations.map { |r| r.id }
      expect(rec_ids).to eq rec_ids.uniq
    end
  end
end
