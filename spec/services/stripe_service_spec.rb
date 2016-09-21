require "rails_helper"

RSpec.describe Worker, type: :object do
  describe ".create_customer" do
    let(:farmer){ FactoryGirl.create(:farmer) }
    context "stripe creates the record successfully" do
      it "saves the stripe customer id" do
        id = "foobar"
        source = "abc"

        expect(Stripe::Customer).to receive(:create).with(
          description: "Customer for #{farmer.email}",
          email: farmer.email,
          source: source
        ).and_return double('customer', id: id)
        
        expect(StripeService.create_customer(farmer.id, source)).to eq true

        expect(farmer.reload.stripe_customer_id).to eq id

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq farmer.id
        expect(pa.action).to eq "Add Card"
        expect(pa.success).to eq true
      end
    end

    context "stripe returns an error" do
      it "create payment audit log and returns false" do
        error = Stripe::InvalidRequestError.new("foo", nil, 400)
        expect(Stripe::Customer).to receive(:create).and_raise(error)
        expect(StripeService.create_customer(farmer.id, "ssss")).to eq false

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq farmer.id
        expect(pa.action).to eq "Add Card"
        expect(pa.success).to eq false
        expect(pa.message).to eq error.to_s
      end
    end
  end
  describe ".update_customer_source" do
    let(:farmer){ FactoryGirl.create(:farmer) }
    context "stripe updates the record successfully" do
      it "returns true" do
        source = "abc"
        customer = double('customer', save: true)
        expect(customer).to receive(:source=).with(source)

        expect(Stripe::Customer).to receive(:retrieve).with(farmer.stripe_customer_id).and_return customer
        
        expect(StripeService.update_customer_source(farmer.id, source)).to eq true

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq farmer.id
        expect(pa.action).to eq "Add Card"
        expect(pa.success).to eq true
      end
    end

    context "stripe returns an error when retrieving the customer record" do
      it "should return false" do
        error = Stripe::InvalidRequestError.new("foo", nil, 400)

        expect(Stripe::Customer).to receive(:retrieve).and_raise(error)
        expect(StripeService.update_customer_source(farmer.id, "ssss")).to eq false

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq farmer.id
        expect(pa.action).to eq "Add Card"
        expect(pa.success).to eq false
        expect(pa.message).to eq error.to_s
      end
    end

    context "stripe returns an error when saving customer fails" do
      it "should return false" do
        error = Stripe::InvalidRequestError.new("foo", nil, 400)
        customer = double('customer')
        expect(customer).to receive(:source=)
        expect(customer).to receive(:save).and_raise(error)
        expect(Stripe::Customer).to receive(:retrieve).and_return customer
        expect(StripeService.update_customer_source(farmer.id, "ssss")).to eq false

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq farmer.id
        expect(pa.action).to eq "Add Card"
        expect(pa.success).to eq false
        expect(pa.message).to eq error.to_s
      end
    end
  end
  describe ".update_customer_email" do
    let(:farmer){ FactoryGirl.create(:farmer) }
    context "stripe updates the record successfully" do
      it "returns true" do
        email = "abc"
        customer = double('customer', save: true)
        expect(customer).to receive(:email=).with(email)

        expect(Stripe::Customer).to receive(:retrieve).with(farmer.stripe_customer_id).and_return customer
        
        expect(StripeService.update_customer_email(farmer.id, "abc")).to eq true
      end
    end

    context "stripe returns an error when retrieving customer record" do
      it "should return false" do
        expect(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::InvalidRequestError)
        expect(StripeService.update_customer_email(farmer.id, "ssss")).to eq false
      end
    end

    context "stripe returns an error when saving customer fails" do
      it "should return false" do
        customer = double('customer')
        expect(customer).to receive(:email=)
        expect(customer).to receive(:save).and_raise(Stripe::InvalidRequestError)
        expect(Stripe::Customer).to receive(:retrieve).and_return customer
        expect(StripeService.update_customer_email(farmer.id, "ssss")).to eq false
      end
    end
  end
  describe ".charge_job" do
    let(:job){ FactoryGirl.create(:job) }
    context "stripe charge succeeds" do
      it "creates a payment audit record and returns true" do
        message = "foobar"
        amount = 100
        charge = double('charge')

        expect(Stripe::Charge).to receive(:create).with(
            customer: job.farmer.stripe_customer_id,
            amount: amount * 100,
            currency: "AUD"
          ).and_return charge
        
        expect(StripeService.charge_job(job.id, amount)).to eq true

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq job.farmer.id
        expect(pa.job_id).to eq job.id
        expect(pa.action).to eq "Charge"
        expect(pa.success).to eq true
        expect(pa.amount).to eq amount
      end
    end

    context "stripe returns an error" do
      it "creates a payment audit record and returns false" do
        error = Stripe::InvalidRequestError.new("foo", nil, 400)
        amount = 10

        expect(Stripe::Charge).to receive(:create).and_raise(error)

        expect(StripeService.charge_job(job.id, amount)).to eq false

        pa = PaymentAudit.last
        expect(pa.farmer_id).to eq job.farmer.id
        expect(pa.job_id).to eq job.id
        expect(pa.action).to eq "Charge"
        expect(pa.success).to eq false
        expect(pa.amount).to eq amount
        expect(pa.message).to eq error.to_s
      end
    end
  end
end