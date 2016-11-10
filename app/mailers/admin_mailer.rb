class AdminMailer < ApplicationMailer
  def previous_employer_review(previous_employer_id, rating, review)
    @previous_employer = PreviousEmployer.find(previous_employer_id)
    @worker = @previous_employer.worker
    @rating = rating
    @review = review

    subject = Rails.env.production? ? "New Review: for #{@worker.email}" : "STAGING - New Review: for #{@worker.email}"
    
    mail(to: Rails.application.config.admin_email, subject: subject)
  end

  def referred_user(referred_user, referred_by_user)
    @referred_user = referred_user
    @referred_by_user = referred_by_user

    subject = Rails.env.production? ? "New Referral" : "STAGING - New Referral"

    mail(to: Rails.application.config.admin_email, subject: subject)
  end
end