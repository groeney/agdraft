class Farmers::OverviewController < Farmers::BaseController
  def index
    @recommended_workers = current_farmer.recommend_workers
  end

  protected
  def nav_item
    @nav_item = "dashboard"
  end
end