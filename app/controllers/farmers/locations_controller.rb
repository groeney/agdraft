class Farmers::LocationsController < Farmers::BaseController
  def show
    @location = current_farmer.location
    @all_locations = Location.all
  end

  def update
    current_farmer.location = Location.find_by!({id: params[:id]})
    current_farmer.save
    render_201
  end

  protected

  def nav_item
    @nav_item = "locations"
  end
end