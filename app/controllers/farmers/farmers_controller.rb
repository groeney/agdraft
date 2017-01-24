class Farmers::FarmersController < Farmers::BaseController
  def edit
    @farmer = current_farmer
  end

  def update
    unless current_farmer.update(secure_params)
      return render_401 "Cannot update the supplied parameters"
    end
    Analytics.track(
      user_id: current_farmer.analytics_id,
      event: "Edit Farm Details",
      properties: {
        business_name: current_farmer.business_name,
        business_description: current_farmer.business_description,
        contact_name: current_farmer.contact_name,
        contact_number: current_farmer.contact_number
      }
    )
    render_204
  end

  protected

  def nav_item
    @nav_item = "farm_details"
  end

  def secure_params
    params.require(:farmer).permit(:business_name, :business_description, :contact_name, :contact_number)
  end
end
