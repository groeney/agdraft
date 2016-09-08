require "rails_helper"

RSpec.describe Workers::CertificatesController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    let(:certificate) { FactoryGirl.build(:certificate, worker: worker).attributes.symbolize_keys! }

    before do
      sign_in worker
      certificate.except!(:id, :created_at, :updated_at)
    end

    it "should create resource" do
      post :create, certificate: certificate
      expect(worker.certificates.where(certificate)).to exist
    end

    context "missing a required attribute" do
      before do
        certificate.except!(:title)
      end

      it "should not create previous employer" do
        post :create, certificate: certificate
        expect(worker.certificates.where(certificate)).not_to exist
      end

      it "should render new" do
        post :create, certificate: certificate
        expect(response).to render_template("new")
      end
    end
  end

  describe "#destroy" do
    let(:worker) { FactoryGirl.create(:worker, :with_certificates) }
    let(:certificate) { worker.certificates.first }
    let(:unowned_resource) { FactoryGirl.create(:certificate) }
    before do
      sign_in worker
    end

    it "should destroy resource" do
      delete :destroy, id: certificate.id, format: :json
      worker.reload
      expect(worker.certificates).not_to include certificate
    end

    it "should respond with 204" do
      delete :destroy, id: certificate.id, format: :json
      expect(response.status).to eq(204)
    end

    it "should not destroy unowned resource" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(Certificate.where({ id: unowned_resource.id })).to exist
    end

    it "should respond with 404" do
      delete :destroy, id: unowned_resource.id, format: :json
      expect(response.status).to eq(404)
    end
  end
end
