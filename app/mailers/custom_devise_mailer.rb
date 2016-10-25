class CustomDeviseMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  # Overrides same inside Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    EmailService.new.send_email(Rails.application.config.smart_email_ids[:farmer_signup], record.email, {full_name: record.full_name, confirmation_url: confirmation_url(record, confirmation_token: token)}) if record.is_a? Farmer
    EmailService.new.send_email(Rails.application.config.smart_email_ids[:worker_signup], record.email, {full_name: record.full_name, confirmation_url: confirmation_url(record, confirmation_token: token)}) if record.is_a? Worker
  end

  # Overrides same inside Devise::Mailer
  def reset_password_instructions(record, token, opts={})
    EmailService.new.send_email(Rails.application.config.smart_email_ids[:reset_password], record.email, {full_name: record.full_name, reset_password_url: edit_password_url(record, reset_password_token: token)})
  end
end