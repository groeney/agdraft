require "rails_helper"

RSpec.describe Farmers::JobsController, type: :controller do
  let(:farmer) { FactoryGirl.create(:farmer) }
  before do
    sign_in farmer
  end

  describe "#create" do
    it "should create the job and associate with farmer" do
      job_params = FactoryGirl.build(:job, farmer: nil).attributes
      job_params[:skills] = []
      job_params[:job_categories] = []
      10.times do 
        job_params[:skills] << FactoryGirl.create(:skill).id
      end
      5.times do 
        job_params[:job_categories] << FactoryGirl.create(:job_category).id
      end
      post :create, job: job_params
      farmer.reload
      expect(response.status).to eq(302)
      expect(farmer.jobs.last.location_id).to eq job_params["location_id"]
      expect(farmer.jobs.last.title).to eq job_params["title"]
      expect(farmer.jobs.last.description).to eq job_params["description"]
      expect(farmer.jobs.last.accomodation_provided).to eq job_params["accomodation_provided"]
      expect(farmer.jobs.last.pay_min).to eq job_params["pay_min"]
      expect(farmer.jobs.last.pay_max).to eq job_params["pay_max"]
      expect(farmer.jobs.last.start_date).to eq job_params["start_date"]
      expect(farmer.jobs.last.end_date).to eq job_params["end_date"]
      expect(farmer.jobs.last.skills.count).to eq 10
      expect(farmer.jobs.last.job_categories.count).to eq 5
    end
  end

  describe "#live" do
    it "should toggle the live value of a job" do
      job = FactoryGirl.create(:job)
      live = job.live
      put :live, id: job.id, format: :json      
      expect(job.reload.live).to eq !live
    end
  end
end