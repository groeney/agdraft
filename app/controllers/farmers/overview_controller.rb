class Farmers::OverviewController < Farmers::BaseController
  def index
  end

  protected
  def nav_item
    @nav_item = "dashboard"
  end
end