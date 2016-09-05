require "rails_helper"

RSpec.describe Workers::SkillsController, type: :controller do
  describe "#index" do
    context "worker has no job categories" do
      let(:worker) { FactoryGirl.create(:worker) }
      before do
        sign_in worker
      end

      it "should redirect to job categories picker" do
        get :index
        expect(response).to redirect_to worker_job_categories_path
      end

      it "should set a flash notice" do
        get :index
        expect(flash[:error]).to be_present
      end
    end

    context "worker has job categories" do
      let(:worker) { FactoryGirl.create(:worker, :with_job_categories) }
      before do
        sign_in worker
      end

      it "should return no selected skills" do
        get :index
        expect(assigns(:selected_skills)).to be_empty
      end
    end

    context "worker has job categories and skills" do
      let(:worker) { FactoryGirl.create(:worker, :with_job_categories, :with_skills) }
      before do
        sign_in worker
      end

      it "should return correct selected skills" do
        get :index
        expect(assigns(:selected_skills)).to eq worker.skills
      end

      it "should return correct eligible skills" do
        get :index
        expect(assigns(:eligible_skills)).to eq worker.eligible_skills
      end
    end
  end

  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:skill) { FactoryGirl.create(:skill) }

    before do
      sign_in worker
    end

    it "should create skill for the worker" do
      post :create, skill: { id: skill.id }, format: :json

      expect(response.status).to eq(201)
      expect(worker.skills).to include skill
    end

    it "should not create duplicate skills for the worker" do
      worker.skills << skill
      post :create, skill: { id: skill.id }, format: :json

      expect(response.status).to eq(201)
      expect(worker.skills.where({id: skill.id}).length).to eq 1
    end

    it "should respond with 404 invalid skill" do
      post :create, skill: { id: 0 }, format: :json
      expect(response.status).to eq(404)
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:skill) { FactoryGirl.create(:skill) }

    before do
      sign_in worker
      worker.skills << skill
    end

    it "should delete workers' skill" do
      delete :destroy, id: skill.id, format: :json
      expect(response.status).to eq(204)
      worker.reload
      expect(worker.skills).not_to include skill
    end

    it "should respond with 404 invalid skill" do
      delete :destroy, id: 0, format: :json
      expect(response.status).to eq(404)
    end

    it "should respond with 404 worker doesn't have skill" do
      new_skill = FactoryGirl.create(:skill)
      delete :destroy, id: new_skill, format: :json
      expect(response.status).to eq(404)
    end
  end
end
