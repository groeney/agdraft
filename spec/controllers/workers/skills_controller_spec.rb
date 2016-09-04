require "rails_helper"

RSpec.describe Workers::SkillsController, type: :controller do
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
