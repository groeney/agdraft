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
  scope "admin", as: "admin", module: "admins" do
    get "/" => "workers#index", as: :dashboard
    delete "/farmer/signout" => "farmer_sessions#destroy", as: :destroy_farmer_session
    delete "/worker/signout" => "worker_sessions#destroy", as: :destroy_worker_session
  end
  scope "farmer", as: "farmer", module: "farmers" do
    get "/" => "overview#index", as: :dashboard
  end
  scope "worker", as: "worker", module: "workers" do
    scope "onboard", as: "onboard" do
      get "job_categories" => "onboard#job_categories"
      get "skills" => "onboard#skills"
    end
    resources :job_categories, only: [:index, :create, :destroy]
    resources :skills, only: [:index, :create, :destroy]
    get "/" => "overview#index", as: :dashboard
  end
end
