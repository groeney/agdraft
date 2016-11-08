class PreviousEmployer < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :worker

  validates_presence_of :worker, :business_name, :job_title
  validates :end_date, presence: true, date: { before: Proc.new { Date.tomorrow }, message: "Must end previous employment before at least #{(Date.tomorrow).to_s}" }, on: [:update, :create]
  validates :start_date, presence: true, date: { before: :end_date }, on: [:update, :create]

  after_create :email_contact

  protected

  def email_contact
    EmailService.new.send_email(Rails.application.config.smart_email_ids[:contact_previous_employer_for_review], contact_email, {worker_name: worker.full_name, job_title: job_title, business_name: business_name, start_date: start_date.strftime("%B %e %Y"), end_date: end_date.strftime("%B %e %Y"), reply_url: previous_employer_review_url(id)}) if contact_email
  end
end
