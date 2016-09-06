require "rails_helper"

RSpec.describe Workers::ExtraDetailsController, type: :controller do
  describe "#update" do
    let(:worker) { FactoryGirl.create(:worker) }
    before do
      sign_in worker
    end
    it "should update has_own_transport" do
      has_own_transport = worker.has_own_transport
      put :update, worker: { has_own_transport: !has_own_transport }, format: :json
      worker.reload
      expect(worker.has_own_transport).to eq(!has_own_transport)
    end

    it "should update tax file number" do
      tax_file_number = Faker::Lorem.word
      put :update, worker: { tax_file_number: tax_file_number }, format: :json
      worker.reload
      expect(worker.tax_file_number).to eq(tax_file_number)
    end

    it "should update nationality" do
      nationality = "Australia"
      put :update, worker: { nationality: nationality }, format: :json
      worker.reload
      expect(worker.nationality).to eq(nationality)
    end

    it "should update mobile number" do
      mobile_number = Faker::PhoneNumber.cell_phone
      put :update, worker: { mobile_number: mobile_number }, format: :json
      worker.reload
      expect(worker.mobile_number).to eq(mobile_number)
    end

    it "should not update first name" do
      new_first_name = Faker::Name.first_name
      put :update, worker: { first_name: new_first_name }, format: :json
      worker.reload
      expect(worker.first_name).not_to eq(new_first_name)
    end
  end
end
