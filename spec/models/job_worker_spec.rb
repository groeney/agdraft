require "rails_helper"

RSpec.describe JobWorker, type: :model do
  context "associations" do
    it { is_expected.to belong_to :job }
    it { is_expected.to belong_to :worker }
  end

  context "validation" do
    it "validates the unqiueness of a worker_id and job_id" do
      job_worker = FactoryGirl.create(:job_worker)
      expect(job_worker.valid?).to eq true
      expect(JobWorker.create(job_id: job_worker.job_id, worker_id: job_worker.worker_id).valid?).to eq false
    end
  end

  context "state machine" do
    context "when state is new" do
      before do
        @job_worker = FactoryGirl.create(:job_worker, :new)
      end

      it { expect(@job_worker).to allow_event(:express_interest) }
      it { expect(@job_worker).to allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:hired) }
      it { expect(@job_worker).to_not allow_event(:declined) }
      it { expect(@job_worker).to_not allow_event(:not_interested) }

      it { expect(@job_worker).to transition_from(:new).to(:interested).on_event(:express_interest) }
      it { expect(@job_worker).to transition_from(:new).to(:shortlisted).on_event(:shortlist) }

      it "triggers state submitted event on interested" do
        expect(@job_worker).to receive(:after_enter_interested_state)
        @job_worker.express_interest
      end
      it "triggers state submitted event on shortlisted" do
        expect(@job_worker).to receive(:after_enter_shortlisted_state)
        @job_worker.shortlist
      end
    end

    context "when state is interested" do
      before do
        @job_worker = FactoryGirl.build(:job_worker, :interested)
      end

      it { expect(@job_worker).to allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:express_interest) }
      it { expect(@job_worker).to_not allow_event(:hire) }
      it { expect(@job_worker).to_not allow_event(:decline) }
      it { expect(@job_worker).to_not allow_event(:no_interest) }

      it "triggers state submitted event on shortlisted" do
        expect(@job_worker).to receive(:after_enter_shortlisted_state)
        @job_worker.shortlist
      end
    end

    context "when state is shortlisted" do
      before do
        @job_worker = FactoryGirl.build(:job_worker, :shortlisted)
      end

      it { expect(@job_worker).to_not allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:express_interest) }
      it { expect(@job_worker).to allow_event(:hire) }
      it { expect(@job_worker).to allow_event(:decline) }
      it { expect(@job_worker).to allow_event(:no_interest) }

      it "triggers state submitted event on hired" do
        expect(@job_worker).to receive(:after_enter_hired_state)
        @job_worker.hire
      end
      it "triggers state submitted event on declined" do
        expect(@job_worker).to receive(:after_enter_declined_state)
        @job_worker.decline
      end
      it "triggers state submitted event on not_interested" do
        expect(@job_worker).to receive(:after_enter_not_interested_state)
        @job_worker.no_interest
      end
    end

    context "when state is hired" do
      before do
        @job_worker = FactoryGirl.build(:job_worker, :hired)
      end

      it { expect(@job_worker).to_not allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:express_interest) }
      it { expect(@job_worker).to_not allow_event(:hire) }
      it { expect(@job_worker).to allow_event(:decline) }
      it { expect(@job_worker).to allow_event(:no_interest) }
    end

    context "when state is declined" do
      before do
        @job_worker = FactoryGirl.build(:job_worker, :declined)
      end

      it { expect(@job_worker).to_not allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:express_interest) }
      it { expect(@job_worker).to_not allow_event(:hire) }
      it { expect(@job_worker).to_not allow_event(:decline) }
      it { expect(@job_worker).to_not allow_event(:no_interest) }
    end

    context "when state is not_interested" do
      before do
        @job_worker = FactoryGirl.build(:job_worker, :not_interested)
      end

      it { expect(@job_worker).to_not allow_event(:shortlist) }
      it { expect(@job_worker).to_not allow_event(:express_interest) }
      it { expect(@job_worker).to_not allow_event(:hire) }
      it { expect(@job_worker).to_not allow_event(:decline) }
      it { expect(@job_worker).to_not allow_event(:no_interest) }
    end
  end
end
