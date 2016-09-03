Rails.application.routes.draw do
  root "pages#home"
  scope 'admin', module: 'admins' do
    get '/' => "workers#index", as: :admin_dashboard
    delete "/farmer/signout" => "farmer_sessions#destroy", as: :destroy_admin_farmer_session
    delete "/worker/signout" => "worker_sessions#destroy", as: :destroy_admin_worker_session
  end
  scope 'farmer', module: 'farmers' do
    get '/' => "overview#index", as: :farmer_dashboard
  end
  scope 'worker', module: 'workers' do
    get '/' => "overview#index", as: :worker_dashboard
  end
end
