require "rails_helper"

RSpec.describe Workers::ReviewsController, type: :controller do
  describe "#create" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    let(:worker) { FactoryGirl.create(:worker) }
    let(:job) { FactoryGirl.create(:job, farmer: farmer, published: true) }
    let(:job_worker) { FactoryGirl.create(:job_worker, job: job, worker: worker) }
    let(:review) { FactoryGirl.build(:review, reviewer: worker, reviewee: farmer).attributes }
    context "farmer has not yet employed worker" do
      before do
        sign_in worker
      end

      it "should respond with 400" do
        post :create, review: review
        expect(response.status).to eq 400
      end

      it "should respond with 400" do
        job_worker.express_interest!
        post :create, review: review
        expect(response.status).to eq 400
      end

      it "should respond with 400" do
        job_worker.shortlist!
        post :create, review: review
        expect(response.status).to eq 400
      end

      it "should respond with 400" do
        job_worker.shortlist!
        job_worker.no_interest!
        post :create, review: review
        expect(response.status).to eq 400
      end

      it "should respond with 400" do
        job_worker.shortlist!
        job_worker.hire!
        job_worker.no_interest!
        post :create, review: review
        expect(response.status).to eq 400
      end
    end

    context "farmer has employed worker" do
      before do
        sign_in worker
        job_worker.hire!
      end
      it "should create review resource" do
        post :create, review: review
        params = { reviewer_id: worker.id, reviewer_type: "Worker", reviewee_id: farmer.id, reviewee_type: "Farmer" }
        expect(Review.where(params).exists?).to be true
      end
      it "should redirect to reviews" do
        post :create, review: review
        expect(response).to redirect_to worker_reviews_by_path
      end
    end
  end

  describe "#new" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    let(:worker) { FactoryGirl.create(:worker) }
    let(:job) { FactoryGirl.create(:job, farmer: farmer, published: true) }
    let(:job_worker) { FactoryGirl.create(:job_worker, job: job, worker: worker) }
    context "worker not yet employed" do
      before do
        sign_in worker
      end
      it "should redirect to reviews" do
        get :new, farmer_id: farmer.id
        expect(response).to redirect_to worker_dashboard_path
      end
    end
  end

  describe "#index_by" do
    let(:worker) { FactoryGirl.create(:worker, :with_reviews) }
    before do
      sign_in worker
    end
    it "should contain correct number of reviews" do
      get :index_by
      expect(assigns(:reviews).count).to eq worker.reviews_by.count
    end

    it "should contain correct reviews" do
      get :index_by
      worker.reviews_by.each do |review|
        expect(assigns(:reviews)).to include review
      end
    end
  end

  describe "#index_of" do
    let(:worker) { FactoryGirl.create(:worker, :with_reviews) }
    before do
      sign_in worker
    end
    it "should contain correct number of reviews" do
      get :index_of
      expect(assigns(:reviews).count).to eq worker.reviews_of.count
    end

    it "should contain correct reviews" do
      get :index_of
      worker.reviews_of.each do |review|
        expect(assigns(:reviews)).to include review
      end
    end
  end
end
