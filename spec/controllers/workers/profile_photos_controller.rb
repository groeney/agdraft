require "rails_helper"

RSpec.describe Workers::ProfilePhotosController, type: :controller do
  let(:worker) { FactoryGirl.create(:worker) }

  describe "#update" do
    context "logged in worker" do
      before :each do 
        sign_in worker
      end
      it "should save the file" do
        post :update, worker: {profile_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'assets', 'image.png'), 'image/png')}
        expect(worker.reload.profile_photo_file_name).to eq "image.png"
      end
    end
  end
end