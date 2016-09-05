class Workers::JobCategoriesController < Workers::BaseController
  def index
    @selected_job_categories = current_worker.job_categories
    @eligible_job_categories = current_worker.eligible_job_categories
  end

  def create
    current_worker.job_categories << JobCategory.find_by!(secure_params)
    render_201
  end

  def destroy
    job_category = current_worker.job_categories.find(params[:id])
    if current_worker.job_categories.destroy(job_category)
      return render_204
    end
    render_404
  end

  protected

  def nav_item
    @nav_item = "job_categories"
  end

  def secure_params
    params.require(:job_category).permit(:id)
  end
end
