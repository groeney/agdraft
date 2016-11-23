class Workers::ReviewsController < Workers::BaseController
  def create
    @worker = Worker.find(params["review"].try(:[], "reviewer_id"))
    @farmer = Farmer.find(params["review"].try(:[], "reviewee_id"))
    return render_400 unless @worker.can_review(@farmer.id)
    @review = Review.create(secure_params)
    unless @review.valid?
      return render "new"
    end
    redirect_to worker_reviews_by_path
  end

  def new
    @farmer = Farmer.find(params[:farmer_id])
    unless current_worker.can_review(@farmer.id)
      flash[:error] = "You have either already reviewed this farmer, or you are not permited to review this farmer"
      return redirect_to worker_dashboard_path
    end
    @review = Review.new
  end

  def index_by
    @reviews = current_worker.reviews_by
    @nav_item = "reviews_by"
  end

  def index_of
    @reviews = current_worker.reviews_of
    @nav_item = "reviews_of"
  end

  protected

  def secure_params
    params.require(:review).permit(:reviewer_id, :reviewer_type, :reviewee_id, :reviewee_type, :feedback, :rating, :job_id)
  end
end
