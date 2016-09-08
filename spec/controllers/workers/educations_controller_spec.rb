require "rails_helper"

RSpec.describe Workers::EducationsController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker, :with_educations) }
    let(:education) { FactoryGirl.build(:education, worker: worker).attributes.symbolize_keys! }

    before do
      sign_in worker
      education.except!(:id, :created_at, :updated_at)
    end

    it "should create resource" do
      post :create, education: education
      expect(worker.educations.where(education)).to exist
    end

    context "missing a required attribute" do
      before do
        education.except!(:school)
      end

      it "should not create previous employer" do
        post :create, education: education
        expect(worker.educations.where(education)).not_to exist
      end

      it "should render new" do
        post :create, education: education
        expect(response).to render_template("new")
      end
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker, :with_educations) }
    let(:education) { worker.educations.first }
    let(:unowned_resource) { FactoryGirl.create(:education) }
    before do
      sign_in worker
    end

    it "should destroy resource" do
      delete :destroy, id: education.id, format: :json
      worker.reload
      expect(worker.educations).not_to include education
    end

    it "should respond with 204" do
      delete :destroy, id: education.id, format: :json
      expect(response.status).to eq(204)
    end

    it "should not destroy unowned resource" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(Education.where({ id: unowned_resource.id })).to exist
    end

    it "should respond with 404" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(response.status).to eq(404)
    end
  end
end
