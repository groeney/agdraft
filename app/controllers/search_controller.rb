class SearchController < ApplicationController
  def workers
    @workers = Worker.where(nil)
    if params["search"]
      @workers = Worker.filter_and((@filter_params = worker_filter_params))
    end
  end

  def jobs
    @jobs = Job.where(nil)
    if params["search"]
      @jobs = Job.filter_and((@filter_params = job_filter_params))
    end
  end

  protected

  def worker_filter_params
    filter_params.slice(:job_categories, :locations, :skills, :start_date, :end_date)
  end

  def job_filter_params
    filter_params.slice(:job_categories, :locations, :skills, :start_date, :end_date)
  end

  def filter_params
    clean_filter_params(params["search"].symbolize_keys)
  end

  def clean_filter_params(filter_params)
    filter_params.each do |key, value|
      filter_params[key] = value.reject { |el| el.blank? } if value.is_a?(Array)
    end
  end
end
