class Workers::UnavailabilitiesController < Workers::BaseController
  def index
    @unavailabilities = current_worker.unavailabilities
  end

  def create
    if (unavailability = current_worker.unavailabilities.create(secure_params)).valid?
      Analytics.track(
        user_id: current_worker.analytics_id,
        event: "Worker Updated Availability"
      )
      return render_201
    end
    render_401 unavailability.errors.full_messages[0]
  end

  def update
    unavailability = current_worker.unavailabilities.find(params[:id])
    if unavailability.update(secure_params)
      return render_204
    end
    render_401 unavailability.errors.full_messages[0]
  end

  def destroy
    current_worker.unavailabilities.find(params[:id]).destroy
    render_204
  end

  protected

  def nav_item
    @nav_item = "unavailabilities"
  end

  def secure_params
    params.require(:unavailability).permit(:start_date, :end_date)
  end
end
