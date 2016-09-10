class Farmers::PaymentsController < Farmers::BaseController
  def show    
    @stripe_publishable_key = Rails.application.config.stripe_publishable_key
  end

  def update
    if current_farmer.stripe_customer_id
      unless StripeService.update_customer_source(current_farmer.id, params_token)
        return render_400
      end
    else
      unless StripeService.create_customer(current_farmer.id, params_token)
        return render_400
      end
    end

    render_201
  end

  protected

  def nav_item
    @nav_item = "payments"
  end

  def params_token
    params.require(:token)
  end
end