class Farmers::FarmersController < Farmers::BaseController
  def edit
    @farmer = current_farmer
  end

  def update
    unless current_farmer.update(secure_params)
      return render_401 "Cannot update the supplied parameters"
    end
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
