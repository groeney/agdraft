class JobWorker < ActiveRecord::Base
  include AASM, Rails.application.routes.url_helpers, TokenSignin

  belongs_to :job
  belongs_to :worker
  validates_uniqueness_of :worker_id, scope: :job_id
  validates_presence_of :worker_id, :job_id

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
      transitions from: :hired, to: :not_interested
    end
  end

  def after_enter_interested_state
    EmailService.new.send_email(
      Rails.application.config.smart_email_ids[:worker_expressed_interest_for_job],
      job.farmer.email,
      {
        job_title: job.title,
        job_url: Rails.application.routes.url_helpers.job_url(job_id),
        worker_full_name: worker.full_name,
        manage_job_url: Rails.application.routes.url_helpers.farmer_manage_job_url(job_id) + token_signin(job.farmer)
      }
    )
  end
  def after_enter_shortlisted_state
    EmailService.new.send_email(
      Rails.application.config.smart_email_ids[:worker_added_to_shortlist],
      worker.email,
      {
        job_title: job.title,
        job_url: Rails.application.routes.url_helpers.job_url(job_id),
        not_interested_url: Rails.application.routes.url_helpers.worker_not_interested_url(id) + token_signin(worker)
      }
    )
    Notification.create(resource: job.farmer,
                        action_path: worker_path(worker.id),
                        thumbnail: worker.profile_photo,
                        header: "You have been hired!",
                        description: "#{job.farmer.full_name} has hired you."
                        )
  end
  def after_enter_hired_state
    unavailability = Unavailability.create(start_date: job.start_date, end_date: job.end_date, worker_id: worker.id)
    EmailService.new.send_email(
      Rails.application.config.smart_email_ids[:worker_hired_by_farmer],
      worker.email,
      {
        job_title: job.title,
        job_url: Rails.application.routes.url_helpers.job_url(job_id),
        worker_first_name: worker.first_name,
        start_date: job.start_date_label,
        end_date: job.end_date_label,
        unavailability_url: Rails.application.routes.url_helpers.worker_unavailabilities_url + token_signin(worker),
        not_interested_url: Rails.application.routes.url_helpers.worker_not_interested_url(id) + token_signin(worker) + "&unavailability_id=#{unavailability.id}"
      }
    )

    Notification.create(resource: worker,
                        action_path: job_path(job.id),
                        thumbnail: job.farmer.profile_photo,
                        header: "You have been hired!",
                        description: "#{job.farmer.full_name} has hired you."
                        )
  end

  def after_enter_declined_state
    EmailService.new.send_email(
      Rails.application.config.smart_email_ids[:worker_declined_by_farmer],
      worker.email,
      {
        job_title: job.title,
        job_url: Rails.application.routes.url_helpers.job_url(job_id),
        worker_first_name: worker.first_name,
        search_jobs_url: Rails.application.routes.url_helpers.search_jobs_url
      }
    )
  end

  def after_enter_not_interested_state
    EmailService.new.send_email(
      Rails.application.config.smart_email_ids[:worker_not_interested],
      job.farmer.email,
      {
        job_title: job.title,
        job_url: Rails.application.routes.url_helpers.job_url(job_id),
        worker_full_name: worker.full_name,
        worker_url: Rails.application.routes.url_helpers.worker_url(worker_id),
        search_workers_url: Rails.application.routes.url_helpers.search_workers_url
      }
    )
  end

  def include_worker_hash
    {
      id: id,
      state: state,
      worker_id: worker.id,
      full_name: worker.full_name,
      profile_photo_url: worker.profile_photo.url(:display),
      mobile_number: worker.mobile_number,
    }
  end
end
