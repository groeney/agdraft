require "rails_helper"

RSpec.describe Farmers::CoverPhotosController, type: :controller do
  let(:farmer) { FactoryGirl.create(:farmer) }

  describe "#update" do
    context "logged in farmer" do
      before :each do 
        sign_in farmer
      end
      it "should save the file" do
        post :update, farmer: {cover_photo: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'assets', 'cover.png'), 'image/png')}
        expect(farmer.reload.cover_photo_file_name).to eq "cover.png"
      end
    end
  end
end