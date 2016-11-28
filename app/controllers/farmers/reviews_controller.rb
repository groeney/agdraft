class Farmers::ReviewsController < Farmers::BaseController
  def create
    @farmer = Farmer.find(params["review"].try(:[], "reviewer_id"))
    @worker = Worker.find(params["review"].try(:[], "reviewee_id"))
    return render_400 unless @farmer.can_review(@worker.id)
    @review = Review.create(secure_params)    
    unless @review.valid?
      return render "new"
    end
    redirect_to farmer_reviews_by_path
  end

  def new
    @worker = Worker.find(params[:worker_id])
    unless current_farmer.can_review(@worker.id)
      flash[:error] = "You cannot submit a review for this worker."
      return redirect_to farmer_dashboard_path
    end
    @review = Review.new
  end

  def index_by
    @reviews = current_farmer.reviews_by
    @nav_item = "reviews_by"
  end

  def index_of
    @reviews = current_farmer.reviews_of
    @nav_item = "reviews_of"
  end

  protected

  def secure_params
    params.require(:review).permit(:reviewer_id, :reviewer_type, :reviewee_id, :reviewee_type, :job_id, :feedback, :rating, :work_ethic, :skills, :communication, :recommended)
  end
end
