module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_and(filter_params)
      available_ids = filter_availability(filter_params)
      results = visibles.where(id: available_ids.uniq)
      filter_params.except(:start_date, :end_date).each do |key, value|
        results = results.public_send(key, value).distinct if value.present?
      end
      results.sort_by { |r| r.filter_rating(filter_params) }.reverse
    end

    def filter_or(filter_params)
      results = self.visibles
      ids = filter_availability(filter_params)
      filter_params.except(:start_date, :end_date).each do |key, value|
        ids << results.public_send(key, value).pluck(:id) if value.present?
      end
      results.where({ id: ids.flatten.uniq }).sort_by { |r| r.filter_rating(filter_params) }.reverse
    end

    protected

    def filter_availability(filter_params)
      start_date, end_date = [filter_params[:start_date], filter_params[:end_date]]
      return self.visibles.pluck(:id) if start_date.blank? || end_date.blank?
      return self.visibles.availability(start_date, end_date).pluck(:id) if self.to_s == "Worker"
      return self.visibles.date_range(start_date, end_date).pluck(:id) if self.to_s == "Job"
    end
  end
end