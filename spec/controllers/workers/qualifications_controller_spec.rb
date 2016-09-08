require "rails_helper"

RSpec.describe Workers::QualificationsController, type: :controller do
  let(:worker) { FactoryGirl.create(:worker, :with_educations, :with_certificates) }
  before do
    sign_in worker
  end

  it "should define educations variable" do
    get :index
    expect(assigns(:educations)).not_to be_nil
  end

  it "should define certificates variable" do
    get :index
    expect(assigns(:certificates)).not_to be_nil
  end
end
