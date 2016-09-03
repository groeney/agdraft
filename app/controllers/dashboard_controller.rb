class DashboardController < ApplicationController
  before_filter :dashboard_type
  layout 'dashboard'  
end