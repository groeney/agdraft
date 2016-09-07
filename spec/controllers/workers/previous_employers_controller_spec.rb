require "rails_helper"

RSpec.describe Workers::PreviousEmployersController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:previous_employer) { FactoryGirl.build(:previous_employer, worker: worker).attributes.symbolize_keys! }

    before do
      sign_in worker
      previous_employer.except!(:id, :created_at, :updated_at)
    end

    it "should create resource" do
      post :create, previous_employer: previous_employer
      expect(worker.previous_employers.where(previous_employer)).to exist
    end

    context "missing a required attribute" do
      before do
        previous_employer.except!(:job_title)
      end

      it "should not create previous employer" do
        post :create, previous_employer: previous_employer
        expect(worker.previous_employers.where(previous_employer)).not_to exist
      end

      it "should render new" do
        post :create, previous_employer: previous_employer
        expect(response).to render_template("new")
      end
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker, :with_previous_employers) }
    let(:previous_employer) { worker.previous_employers.first }
    let(:unowned_resource) { FactoryGirl.create(:previous_employer) }
    before do
      sign_in worker
    end

    it "should destroy resource" do
      delete :destroy, id: previous_employer.id, format: :json
      worker.reload
      expect(worker.previous_employers).not_to include previous_employer
    end

    it "should respond with 204" do
      delete :destroy, id: previous_employer.id, format: :json
      expect(response.status).to eq(204)
    end

    it "should not destroy unowned resource" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(PreviousEmployer.where({ id: unowned_resource.id })).to exist
    end

    it "should respond with 404" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(response.status).to eq(404)
    end
  end

  describe "#index" do
    let(:worker) { FactoryGirl.create(:worker, :with_previous_employers) }
    before do
      sign_in worker
    end

    it "should return correct previous employers" do
      get :index
      expect(assigns(:previous_employers)).to eq worker.previous_employers
    end
  end
end