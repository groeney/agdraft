class Farmers::CoverPhotosController < Farmers::BaseController
  def show
    @farmer = current_farmer
  end

  def edit
    @farmer = current_farmer
  end

  def update
    @farmer = current_farmer
    if @farmer.update_attributes(farmer_params)
      render "show"
    else
      render "edit"
    end
  end

  protected

  def nav_item
    @nav_item = "cover_photo"
  end

  def farmer_params
    params.require(:farmer).permit(:cover_photo)
  end
end