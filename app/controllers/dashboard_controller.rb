class DashboardController < ApplicationController
  before_filter :dashboard_type
  before_filter :nav_item
  before_filter :notifications
  layout "dashboard"

  private

  def nav_item
  end

  def notifications
    if (current_resource = current_farmer || current_worker)
      @unseen_notifications = current_resource.notifications.where({ unseen: true }).exists?
    end
  end
end