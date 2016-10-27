require "rails_helper"

RSpec.describe SearchController, type: :controller do
  describe "#workers" do
    let(:skill) { FactoryGirl.create(:skill) }
    let(:job_category) { FactoryGirl.create(:job_category) }
    let(:location) { FactoryGirl.create(:location) }
    let(:start_date) { 10.days.from_now }
    let(:end_date) { 30.days.from_now }
    let!(:plain_workers) { FactoryGirl.create_list(:worker, 5) }
    let!(:unavailable_workers) { FactoryGirl.create_list(:worker, 5, :with_unavailabilities, start_date: start_date, end_date: end_date) }
    let!(:allrounder_workers) { FactoryGirl.create_list(:worker, 5, :with_skills, :with_job_categories, :with_locations, skills: skill, job_categories: job_category, locations: location, verified: true) }

    context "no search filters set (initial search page load)" do
      it "should return correct number and correct Workers" do
        get :workers
        expect(assigns(:workers).count).to eq Worker.visibles.count
        Worker.visibles.each do |worker|
          expect(assigns(:workers)).to include worker
        end
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

      it "should return correct number of workers" do
        get :workers, search: params
        allrounder_workers.each do |worker|
          expect(assigns(:workers)).to include worker
        end
      end
    end
  end

  describe "#jobs" do
    let(:skill) { FactoryGirl.create(:skill) }
    let(:job_category) { FactoryGirl.create(:job_category) }
    let(:location) { FactoryGirl.create(:location) }
    let(:start_date) { 10.days.from_now }
    let(:end_date) { 30.days.from_now }

    let!(:plain_jobs) { FactoryGirl.create_list(:job, 5) }
    let!(:allrounder_jobs) { FactoryGirl.create_list(:job, 5, :with_skills, :with_job_categories, skills: skill, job_categories: job_category, location: location, published: true) }

    context "no search filters set (initial search page load)" do
      it "should return correct number and correct Jobs" do
        get :jobs
        expect(assigns(:jobs).count).to eq Job.visibles.count
        Job.visibles.each do |job|
          expect(assigns(:jobs)).to include job
        end
      end
    end

    context "all search filters set" do
      let(:params) { { job_categories: [job_category.id.to_s], skills: [skill.id.to_s], locations: [location.id.to_s] } }

      it "should call the appropriate class methods" do
        expect(Job).to receive(:filter_and).with(params)
        get :jobs, search: params
      end

      it "should return correct number of jobs" do
        get :jobs, search: params
        expect(assigns(:jobs).count).to eq(allrounder_jobs.count)
      end

      it "should return correct number of jobs" do
        get :jobs, search: params
        allrounder_jobs.each do |job|
          expect(assigns(:jobs)).to include job
        end
      end
    end
  end
end
