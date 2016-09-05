require "rails_helper"

RSpec.describe Workers::OnboardController, type: :controller do
  describe "#skills" do
    context "worker has no job categories" do
      let(:worker) { FactoryGirl.create(:worker) }
      before do
        sign_in worker
      end
      it "should redirect worker to job categories picker" do
        get :skills
        expect(response).to redirect_to worker_onboard_job_categories_path
      end

      it "should set flash error" do
        get :skills
        expect(flash[:error]).to be_present
      end
    end

    context "worker has job categories" do
      let(:worker) { FactoryGirl.create(:worker, :with_job_categories) }
      before do
        sign_in worker
      end
      it "should return empty selected skills" do
        get :skills
        expect(assigns(:selected_skills)).to be_empty
      end
    end

    context "worker has job categories and skills" do
      let(:worker) { FactoryGirl.create(:worker, :with_job_categories, :with_skills) }
      before do
        sign_in worker
      end

      it "should return correct selected skills" do
        get :skills
        expect(assigns(:selected_skills)).to eq worker.skills
      end

      it "should return correct eligible skills" do
        get :skills
        expect(assigns(:eligible_skills)).to eq worker.eligible_skills
      end
    end
  end
end
