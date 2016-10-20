class Workers::ExtraDetailsController < Workers::BaseController
  def show
    @worker = current_worker
  end

  def update
    if current_worker.update(secure_params)
      return render_204
    end
    render_401 "Cannot update the supplied parameters"
  end

  protected

  def nav_item
    @nav_item = "extra_details"
  end

  def secure_params
    params.require(:worker).permit(:has_own_transport, :tax_file_number, :dob,
                                   :abn, :mobile_number, :nationality,
                                  :description, :passport_number,
                                  :grew_up_on_farm, :has_own_accommodation)
  end
end
