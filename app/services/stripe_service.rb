class StripeService
  def self.create_customer(farmer_id, source)    
    farmer = Farmer.find(farmer_id)
    begin
      customer = Stripe::Customer.create(
        :description => "Customer for #{farmer.email}",
        :email => farmer.email,
        :source => source
      )
    rescue
      return false
    end

    farmer.stripe_customer_id = customer.id
    farmer.save
  end

  def self.update_customer_source(farmer_id, token)
    farmer = Farmer.find(farmer_id)
    begin      
      customer = Stripe::Customer.retrieve(farmer.stripe_customer_id)
      customer.source = token
      customer.save
    rescue
      return false
    end
    true
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
    true
  end
end