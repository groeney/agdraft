class FarmersController < ApplicationController
  impressionist
  layout "hero"
  def show
    @farmer = Farmer.find(params[:id])
  end
end