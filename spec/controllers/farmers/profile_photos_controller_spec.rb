require "rails_helper"

RSpec.describe Farmers::ProfilePhotosController, type: :controller do
  let(:farmer) { FactoryGirl.create(:farmer) }

  describe "#update" do
    context "logged in farmer" do
      before :each do 
        sign_in farmer
      end
      it "should save the file" do
        post :update, farmer: {profile_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'assets', 'image.png'), 'image/png')}
        expect(farmer.reload.profile_photo_file_name).to eq "image.png"
      end
    end
  end
end