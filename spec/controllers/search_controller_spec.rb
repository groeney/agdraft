require "rails_helper"

RSpec.describe SearchController, type: :controller do
  describe "#workers" do
    let(:skill) { FactoryGirl.create(:skill) }
    let(:job_category) { FactoryGirl.create(:job_category) }
    let(:location) { FactoryGirl.create(:location) }
    let(:start_date) { 10.days.from_now }
    let(:end_date) { 30.days.from_now }
    let!(:plain_workers) { FactoryGirl.create_list(:worker, 20) }
    let!(:allrounder_workers) { FactoryGirl.create_list(:worker, 20, :with_skills, :with_job_categories, :with_locations, skills: skill, job_categories: job_category, locations: location) }

    context "no search filters set (initial search page load)" do
      it "should return all Workers" do
        get :workers, search: {}
        expect(assigns(:workers).count).to eq Worker.all.count
      end

      it "should return all Workers" do
        get :workers
        expect(assigns(:workers).count).to eq Worker.all.count
      end
    end

    context "all search filters set" do
      let(:params) { { job_categories: [job_category.id.to_s], skills: [skill.id.to_s], locations: [location.id.to_s] } }
      it "should call the appropriate class methods" do
        expect(Worker).to receive(:filter_and).with(params)
        get :workers, search: params
      end

      it "should return correct number of workers" do
        get :workers, search: params
        expect(assigns(:workers).count).to eq(allrounder_workers.count)
      end
    end
  end
end
