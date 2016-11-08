class AdminMailer < ApplicationMailer
  def previous_employer_review(previous_employer_id, rating, review)
    @previous_employer = PreviousEmployer.find(previous_employer_id)
    @worker = @previous_employer.worker
    @rating = rating
    @review = review
    mail(to: Rails.application.config.admin_email, subject: "New Review: for #{@worker.email}")
  end
end