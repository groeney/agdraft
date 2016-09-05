require "rails_helper"

RSpec.describe Workers::UnavailabilitiesController, type: :controller do
  describe "#create" do
    let(:worker) { FactoryGirl.create(:worker) }
    before do
      sign_in worker
    end

    context "valid date params" do
      let(:start_date) { Time.now }
      let(:end_date) { 10.days.from_now }

      it "should respond with 201 created" do
        post :create, unavailability: { start_date: start_date, end_date: end_date }, format: :json
        expect(response.status).to eq(201)
      end

      it "should create new unavailability for worker" do
        original_count = worker.unavailabilities.count
        post :create, unavailability: { start_date: start_date, end_date: end_date }, format: :json
        expect(worker.unavailabilities.count).to eq(original_count + 1)
      end

      it "should create correct unavailability" do
        post :create, unavailability: { start_date: start_date, end_date: end_date }, format: :json
        expect(worker.unavailabilities.where({ worker_id: worker.id, start_date: start_date, end_date: end_date })).to exist
      end
    end

    context "invalid date params" do
      let(:start_date) { Time.now }
      let(:end_date) { 10.days.from_now }
      let(:invalid_start_date) { 10.days.ago }
      let(:invalid_end_date) { 100.days.ago }

      it "should respond with 401 with invalid_start_date" do
        post :create, unavailability: { start_date: invalid_start_date, end_date: end_date }, format: :json
        expect(response.status).to eq(401)
      end

      it "should respond with 401 with invalid_end_date" do
        post :create, unavailability: { start_date: start_date, end_date: invalid_end_date }, format: :json
        expect(response.status).to eq(401)
      end

      it "should respond with 401 with nil params" do
        post :create, unavailability: { start_date: nil, end_date: nil }, format: :json
        expect(response.status).to eq(401)
      end
    end
  end

  describe "#update" do
    let(:worker) { FactoryGirl.create(:worker, :with_unavailabilities) }
    let(:unavailability) { worker.unavailabilities.first }
    before do
      sign_in worker
    end

    context "valid date params" do
      let(:start_date) { 10.days.from_now }
      let(:end_date) { 100.days.from_now }

      it "should respond with 204 updated" do
        put :update, id: unavailability.id, unavailability: { start_date: start_date, end_date: end_date }, format: :json
        expect(response.status).to eq(204)
      end

      it "should update to correct unavailability" do
        put :update, id: unavailability.id, unavailability: { start_date: start_date, end_date: end_date }, format: :json
        expect(worker.unavailabilities.where({ worker_id: worker.id, start_date: start_date, end_date: end_date })).to exist
      end
    end

    context "invalid date params" do
      let(:start_date) { Time.now }
      let(:end_date) { 10.days.from_now }
      let(:invalid_start_date) { 10.days.ago }
      let(:invalid_end_date) { 100.days.ago }

      it "should respond with 401 with invalid_start_date" do
        put :update, id: unavailability.id, unavailability: { start_date: invalid_start_date, end_date: end_date }, format: :json
        expect(response.status).to eq(401)
      end

      it "should respond with 401 with invalid_end_date" do
        put :update, id: unavailability.id, unavailability: { start_date: start_date, end_date: invalid_end_date }, format: :json
        expect(response.status).to eq(401)
      end

      it "should respond with 401 with nil params" do
        put :update, id: unavailability.id, unavailability: { start_date: nil, end_date: nil }, format: :json
        expect(response.status).to eq(401)
      end
    end
  end
end
