class Workers::NotificationsController < Workers::BaseController
  def index
    @notifications = current_worker.notifications.where({ unseen: true }).reverse
    @unseen_notifications = @notifications.count > 0
  end

  def show
    @notification = current_worker.notifications.find(params[:id])
    @notification.update unseen: false
    redirect_to @notification.action_path
  end
end
