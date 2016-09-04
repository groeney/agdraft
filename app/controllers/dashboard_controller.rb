class DashboardController < ApplicationController
  before_filter :dashboard_type
  before_filter :nav_item
  layout 'dashboard'

  private

  def nav_item
  end
end