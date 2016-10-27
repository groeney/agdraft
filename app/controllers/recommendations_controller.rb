class RecommendationsController < ApplicationController
  def block_job
    recommendation = current_worker.recommendations.find(params[:id])
    unless recommendation.update blocked: true
      return render_401
    end
    render_200
  end
end
