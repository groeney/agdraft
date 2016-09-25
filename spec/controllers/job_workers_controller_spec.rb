require "rails_helper"

RSpec.describe JobWorkersController, type: :controller do
  describe "#index" do
    context "signed in as farmer" do
      before do
        @farmer = FactoryGirl.create(:farmer, :with_job)
        sign_in @farmer
      end
      context "with a valid job_id" do
        it "returns 200 with job_workers as json" do
          job_worker = FactoryGirl.create(:job_worker, job: @farmer.jobs.first)
          get :index, job_id: @farmer.jobs.first.id, format: :json
          expect(response.status).to eq 200
          data = JSON.parse(response.body)
          expect(data.length).to eq 1
          expect(data[0]).to eq JSON.parse(job_worker.to_json)
        end
      end
      context "with an invalid job_id" do
        it "returns a 401" do
          get :index, job_id: 0, format: :json
          expect(response.status).to eq 401
        end
      end
      context "with a job_id that does not belong to the farmer" do
        it "returns a 401" do
          job = FactoryGirl.create(:job)
          get :index, job_id: job.id, format: :json
          expect(response.status).to eq 401
        end
      end
    end
    context "not signed in as farmer" do
      it "returns a 401" do
        get :index, job_id: 0, format: :json
        expect(response.status).to eq 401
      end
    end
  end
  describe "#express_interest" do
    before do
      @job = FactoryGirl.create(:job)
    end
    context "when a worker is signed in" do
      before do
        @worker = FactoryGirl.create(:worker)
        sign_in @worker
      end
      context "when a job_id is sent" do
        context "when a worker has not yet expressed interest in a job" do
          it "creates the job worker record and sets interested state" do
            post :express_interest, job_id: @job.id, format: :json
            expect(response.status).to eq 201
            job_worker = JobWorker.last
            expect(job_worker.job_id).to eq @job.id
            expect(job_worker.worker_id).to eq @worker.id
            expect(job_worker.state).to eq "interested"
          end
        end
        context "when a workers has already express interest in a job" do
          before do 
            JobWorker.create(job: @job, worker: @worker).express_interest
          end
          it "returns a 400" do
            post :express_interest, job_id: @job.id, format: :json
            expect(response.status).to eq 400
          end
        end
      end
      context "when an invalid job_id is sent" do
        it "returns a 400" do
          post :express_interest, job_id: 0, format: :json
          expect(response.status).to eq 400
        end
      end
    end
    context "when a worker is not signed in" do
      it "returns a 401" do
        post :express_interest, job_id: @job.id, format: :json
        expect(response.status).to eq 401
      end
    end
  end

  describe "#shortlist" do
    before do
      @job = FactoryGirl.create(:job)
      @worker = FactoryGirl.create(:worker)
    end
    context "when a farmer is signed it" do
      before do
        @farmer = FactoryGirl.create(:farmer)
        sign_in @farmer
      end
      context "when the worker has not yet been shortlisted" do
        it "creates the job worker record and sets shortlisted state" do
          post :shortlist, job_id: @job.id, worker_id: @worker.id, format: :json
          job_worker = JobWorker.last
          expect(job_worker.job_id).to eq @job.id
          expect(job_worker.worker_id).to eq @worker.id
          expect(job_worker.state).to eq "shortlisted"
        end
      end
      context "when the worker has already been shortlisted" do
        before do
          JobWorker.create(job: @job, worker: @worker).shortlist
        end
        it "returns a 400" do
          post :shortlist, job_id: @job.id, worker_id: @worker.id, format: :json
          expect(response.status).to eq 400
        end
      end
      context "when a job_id or worker_id is invalid" do
        it "returns a 400" do
          post :shortlist, job_id: @job.id, worker_id: 0, format: :json
          expect(response.status).to eq 400
        end
      end
    end

    context "when a farmer is not signed in" do
      it "returns a 400" do
        post :shortlist, job_id: @job.id, worker_id: @worker.id, format: :json
        expect(response.status).to eq 401
      end
    end
  end

  describe "#transition" do
    context "when a farmer is signed in" do
      before do
        @farmer = FactoryGirl.create(:farmer, :with_job)
        sign_in @farmer
      end
      context "a valid job_worker_id is specified" do
        before do
          @job_worker = FactoryGirl.create(:job_worker, job: @farmer.jobs.first)
        end
        it "returns 200 when valid state transition" do
          transition = "hire"
          expect_any_instance_of(JobWorker).to receive(:hire!).and_return true
          post :transition, job_worker_id: @job_worker.id, transition: transition, format: :json
          expect(response.status).to eq 200
        end
        it "returns the job_worker id and status" do
          @job_worker.shortlist!
          post :transition, job_worker_id: @job_worker.id, transition: "hire", format: :json
          json = JSON.parse(response.body)          
          expect(json["state"]).to eq "hired"
        end
        it "returns 400 on invalid state transition" do
          transition = "hire"
          expect_any_instance_of(JobWorker).to receive(:hire!).and_return false
          post :transition, job_worker_id: @job_worker.id, transition: transition, format: :json
          expect(response.status).to eq 400
        end
      end
      context "when a invalid job_worker_id is specified" do
        it "returns a 404" do
          post :transition, job_worker_id: 0, transition: "foo", format: :json
          expect(response.status).to eq 404
        end
      end
      context "when a job_worker_id is specified that doesn't belong to the farmer" do
        it "returns a 401" do
          job_worker = FactoryGirl.create(:job_worker)
          post :transition, job_worker_id: job_worker.id, transition: "foo", format: :json
          expect(response.status).to eq 401
        end
      end
    end
    context "when a worker is signed in" do
      before do
        @worker = FactoryGirl.create(:worker)
        sign_in @worker
      end
      context "the worker_id specified is the current_worker" do
        before do
          @job_worker = FactoryGirl.create(:job_worker, worker: @worker)
        end
        it "allows no_interest" do
          @job_worker.shortlist!
          post :transition, job_worker_id: @job_worker.id, transition: "no_interest", format: :json
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)["state"]).to eq "not_interested"
        end
        it "does not allow transitions other than no_interest" do
          post :transition, job_worker_id: @job_worker.id, transition: "hire", format: :json
          expect(response.status).to eq 400
        end
      end
      context "the worker_id is not the current_worker" do
        before do
          @job_worker = FactoryGirl.create(:job_worker)
        end
        it "returns a 400" do
          post :transition, job_worker_id: @job_worker.id, transition: "no_interest", format: :json
          expect(response.status).to eq 401
        end
      end
      context "an invalid job_worker_id is specified" do
        it "returns a 404" do
          post :transition, job_worker_id: 0, transition: "no_interest", format: :json
          expect(response.status).to eq 404
        end
      end
    end
    context "when not signed in" do
      it "returns 401" do
        post :transition, job_worker_id: 0, transition: "no_interest", format: :json
        expect(response.status).to eq 401
      end
    end
  end
end