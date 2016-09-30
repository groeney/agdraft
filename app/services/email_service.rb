require 'createsend'
class EmailService
  def send_email(smart_email_id, email, template_content = [])
    if Rails.env.development? || Rails.env.test?
      write_to_cmd_line(email, smart_email_id, template_content.inspect)
    else    
      delay.make_request(smart_email_id, email, template_content)
    end
  end

  protected

  def make_request(smart_email_id, email, template_content = [])
    return if email.split("@")[1] == "example.com"
    message = message_to(email, template_content)
    auth = {:api_key => Rails.application.config.campaign_monitor_api_key}
    tx_smart_mailer = CreateSend::Transactional::SmartEmail.new(auth, smart_email_id)    
    tx_smart_mailer.send(message)
  end

  # used only for development
  def write_to_cmd_line(email, smart_email_id, content)
    log = "\n\n\n\n\n" 
    log += "#############   EMAIL SENT TO: #{email}   ############\n"
    log += "TEMPLATE: #{smart_email_id}\n"
    log += "#{content}\n"
    log += "###########################################################"
    log += "\n\n\n\n\n"
    Rails.logger.info log
  end

  # builds the headers and content of email
  def message_to(email, content)
    {
      'To' => email,
      'Data' => content
    }
  end
end