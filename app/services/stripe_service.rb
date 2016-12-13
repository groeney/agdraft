class StripeService
  def self.create_customer(farmer_id, source)    
    farmer = Farmer.find(farmer_id)
    begin
      customer = Stripe::Customer.create(
        :description => "Customer for #{farmer.email}",
        :email => farmer.email,
        :source => source
      )
    rescue Exception => e
      PaymentAudit.create(
        farmer_id: farmer_id, 
        message: e.to_s, 
        action: "Add Card", 
        success: false
      )
      return false
    end
    PaymentAudit.create(
      farmer_id: farmer_id, 
      action: "Add Card", 
      success: true
    )

    farmer.stripe_customer_id = customer.id
    farmer.save
  end

  def self.update_customer_source(farmer_id, token)
    farmer = Farmer.find(farmer_id)
    begin      
      customer = Stripe::Customer.retrieve(farmer.stripe_customer_id)
      customer.source = token
      res = customer.save
    rescue Exception => e
      PaymentAudit.create(
        farmer_id: farmer_id, 
        message: e.to_s, 
        action: "Add Card", 
        success: false
      )
      return false
    end
    PaymentAudit.create(
      farmer_id: farmer_id, 
      action: "Add Card", 
      success: true
    )
    return true
  end

  def self.update_customer_email(farmer_id, email)
    farmer = Farmer.find(farmer_id)
    begin
      customer = Stripe::Customer.retrieve(farmer.stripe_customer_id)
      customer.email = email
      customer.save
    rescue
      return false
    end
    return true
  end

  def self.charge_job(job_id, amount)
    job = Job.find(job_id)
    begin
      charge = Stripe::Charge.create(
        customer: job.farmer.stripe_customer_id,
        amount: amount #syripe takes amounts in dollara
        currency: "AUD"
      )
    rescue Exception => error
      PaymentAudit.create(
        farmer_id: job.farmer_id, 
        job_id: job.id, 
        message: error.to_s, 
        action: "Charge", 
        amount: amount,
        success: false
      )
      return false
    end
    PaymentAudit.create(
      farmer_id: job.farmer_id, 
      job_id: job.id, 
      action: "Charge", 
      amount: amount,
      success: true
    )
    return true
  end
end
