require "rails_helper"

RSpec.describe Farmers::ReviewsController, type: :controller do
  describe "#create" do
    let(:farmer) { FactoryGirl.create(:farmer) }
    let(:worker) { FactoryGirl.create(:worker) }
    let(:job) { FactoryGirl.create(:job, farmer: farmer, published: true) }
    let(:job_worker) { FactoryGirl.create(:job_worker, job: job, worker: worker) }
    let(:review) { FactoryGirl.build(:review, reviewer: farmer, reviewee: worker).attributes }
    context "farmer has not yet employed worker" do
      before do
        sign_in farmer
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
        sign_in farmer
        job_worker.hire!
      end
      it "should create review resource" do
        post :create, review: review
        params = { reviewer_id: farmer.id, reviewer_type: "Farmer", reviewee_id: worker.id, reviewee_type: "Worker" }
        expect(Review.where(params).exists?).to be true
      end
      it "should redirect to reviews" do
        post :create, review: review
        expect(response).to redirect_to farmer_reviews_by_path
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
        sign_in farmer
      end
      it "should redirect to reviews" do
        get :new, worker_id: worker.id
        expect(response).to redirect_to farmer_dashboard_path
      end
    end
  end

  describe "#index_by" do
    let(:farmer) { FactoryGirl.create(:farmer, :with_reviews) }
    before do
      sign_in farmer
    end
    it "should contain correct number of reviews" do
      get :index_by
      expect(assigns(:reviews).count).to eq farmer.reviews_by.count
    end

    it "should contain correct reviews" do
      get :index_by
      farmer.reviews_by.each do |review|
        expect(assigns(:reviews)).to include review
      end
    end
  end

  describe "#index_of" do
    let(:farmer) { FactoryGirl.create(:farmer, :with_reviews) }
    before do
      sign_in farmer
    end
    it "should contain correct number of reviews" do
      get :index_of
      expect(assigns(:reviews).count).to eq farmer.reviews_of.count
    end

    it "should contain correct reviews" do
      get :index_of
      farmer.reviews_of.each do |review|
        expect(assigns(:reviews)).to include review
      end
    end
  end
end
