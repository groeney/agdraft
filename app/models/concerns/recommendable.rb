module Recommendable
  extend ActiveSupport::Concern

  module ClassMethods
    def recommend(filter_params, except = [], size = 5)
      results = self.filter_or(filter_params)
      results |= self.all if results.count < size
      results.uniq.select { |r| !except.include?(r.id) }.first(size)
    end
  end
end