class Workers::LocationsController < Workers::BaseController
  def index
    @locations = current_worker.locations
  end

  def new
    @worker_locations = current_worker.locations
    @all_locations = Location.all
  end

  def create
    current_worker.locations << Location.find_by!({id: params[:id]})
    render_201
  end

  def destroy
    location = current_worker.locations.find(params[:id])
    if current_worker.locations.destroy(location)
      return render_204
    else
      render_404
    end
  end

  protected

  def nav_item
    @nav_item = "locations"
  end
end