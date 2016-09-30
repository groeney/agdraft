module Recommendable
  extend ActiveSupport::Concern

  module ClassMethods
    def recommend(filter_params, except = [], size = 5)
      results = self.filter_or(filter_params)
      results.select { |r| !except.include?(r.id) }.first(size)
    end
  end
end