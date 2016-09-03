Rails.application.routes.draw do
  root "pages#home"
  devise_for :admins, controllers: {
    sessions: "farmers/sessions"
  }
  devise_for :farmers, controllers: {
    registrations: "farmers/registrations",
    sessions: "farmers/sessions",
    confirmations: "farmers/confirmations"
  }
  devise_for :workers, controllers: {
    registrations: "workers/registrations",
    sessions: "workers/sessions",
    confirmations: "workers/confirmations"
  }
  scope "admin", module: "admins" do
    get "/" => "workers#index", as: :admin_dashboard
    delete "/farmer/signout" => "farmer_sessions#destroy", as: :destroy_admin_farmer_session
    delete "/worker/signout" => "worker_sessions#destroy", as: :destroy_admin_worker_session
  end
  scope "farmer", module: "farmers" do
    get "/" => "overview#index", as: :farmer_dashboard
  end
  scope "worker", module: "workers" do
    get "job_categories" => "onboard#job_categories"
    get "skills" => "onboard#skills"
    resources :job_categories, only: [:create, :destroy]
    resources :skills, only: [:create, :destroy]
    get "/" => "overview#index", as: :worker_dashboard
  end
end
