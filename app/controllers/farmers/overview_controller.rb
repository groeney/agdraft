class Farmers::OverviewController < Farmers::BaseController
  def index
    @recommended_workers = current_farmer.recommended_workers
  end

  protected

  def nav_item
    @nav_item = "dashboard"
  end

  def filter_params
    { skills: skill_ids, job_categories: job_category_ids, locations: location_ids }
  end

  def skill_ids
    current_farmer.jobs.map { |j| j.skills.pluck(:id) }.flatten.uniq
  end

  def job_category_ids
    current_farmer.jobs.map { |j| j.job_categories.pluck(:id) }.flatten.uniq
  end

  def location_ids
    current_farmer.jobs.map { |j| j.location.id }.flatten.uniq
  end
end