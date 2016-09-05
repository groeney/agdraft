require "rails_helper"

RSpec.describe Workers::OnboardController, type: :controller do
  describe "#skills" do
    let(:worker) { FactoryGirl.create(:worker) }
    before do
      sign_in worker
    end
    it "should redirect worker to job_categories_path" do
      get :skills
      expect(response).to redirect_to worker_onboard_job_categories_path
    end
  end
end
