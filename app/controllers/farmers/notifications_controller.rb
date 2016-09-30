class Farmers::NotificationsController < Farmers::BaseController
  def index
    @notifications = current_farmer.notifications.where({ unseen: true })
    @unseen_notifications = @notifications.count > 0
  end

  def show
    @notification = current_farmer.notifications.find(params[:id])
    @notification.update unseen: false
    redirect_to @notification.action_path
  end
end
