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
      end
    end

    context "stripe returns an error" do
      it "should return false" do
        expect(Stripe::Customer).to receive(:create).and_raise(Stripe::InvalidRequestError)
        expect(StripeService.create_customer(farmer.id, "ssss")).to eq false
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
      end
    end

    context "stripe returns an error when retrieving the customer record" do
      it "should return false" do
        expect(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::InvalidRequestError)
        expect(StripeService.update_customer_source(farmer.id, "ssss")).to eq false
      end
    end

    context "stripe returns an error when saving customer fails" do
      it "should return false" do
        customer = double('customer')
        expect(customer).to receive(:source=)
        expect(customer).to receive(:save).and_raise(Stripe::InvalidRequestError)
        expect(Stripe::Customer).to receive(:retrieve).and_return customer
        expect(StripeService.update_customer_source(farmer.id, "ssss")).to eq false
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
end