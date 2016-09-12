class SearchController < ApplicationController
  def workers
    @workers = Worker.where(nil)
    if params["search"]
      @filter_params = worker_filter_params
      @workers = Worker.filter_and(@filter_params)
    end
  end

  protected

  def worker_filter_params
    filter_params = params["search"].symbolize_keys
    filter_params.each do |key, value|
      filter_params[key] = value.reject { |el| el.blank? } if value.is_a?(Array)
    end
    filter_params.slice(:job_categories, :locations, :skills, :start_date, :end_date)
  end
end
