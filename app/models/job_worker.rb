class JobWorker < ActiveRecord::Base
  include AASM
  
  belongs_to :job
  belongs_to :worker
  validates_uniqueness_of :worker_id, scope: :job_id

  aasm column: :state, whiny_transitions: false do
    state :new, initial: true
    state :interested,   after_enter: :after_enter_interested_state
    state :shortlisted,   after_enter: :after_enter_shortlisted_state
    state :hired,   after_enter: :after_enter_hired_state
    state :declined,   after_enter: :after_enter_declined_state
    state :not_interested,   after_enter: :after_enter_not_interested_state

    event :express_interest do
      transitions from: :new, to: :interested
    end
    event :shortlist do
      transitions from: :new, to: :shortlisted
      transitions from: :interested, to: :shortlisted
    end
    event :hire do
      transitions from: :shortlisted, to: :hired
    end
    event :decline do
      transitions from: :shortlisted, to: :declined
    end
    event :no_interest do
      transitions from: :shortlisted, to: :not_interested
    end
  end

  def after_enter_interested_state

  end
  def after_enter_shortlisted_state

  end
  def after_enter_hired_state

  end
  def after_enter_declined_state

  end
  def after_enter_not_interested_state

  end
end
