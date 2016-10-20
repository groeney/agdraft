Rails.application.routes.draw do
  devise_for :admins, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  comfy_route :cms_admin, :path => '/cms'

  root "pages#home"
  get "/search/workers" => "search#workers", as: :search_workers
  get "/search/jobs" => "search#jobs", as: :search_jobs
  get "/get_started" => "pages#get_started", as: :get_started
  get "/login" => "pages#login", as: :login

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

  scope "farmer", as: "farmer", module: "farmers" do
    get "/" => "overview#index", as: :dashboard

    get "profile_photo" => "profile_photos#show", as: :profile_photo
    get "profile_photo/edit" => "profile_photos#edit", as: :edit_profile_photo
    put "profile_photo" => "profile_photos#update"

    get "cover_photo" => "cover_photos#show", as: :cover_photo
    get "cover_photo/edit" => "cover_photos#edit", as: :edit_cover_photo
    put "cover_photo" => "cover_photos#update"

    # if 'show' is added to resources then update does not get named path which is needed for js-routes plugin
    get "location" => "locations#show", as: :show_location
    resources :locations, only: [:update]
    resources :farmers, only: [:edit, :update]
    resources :notifications, only: [:index, :show]

    post "seeds/jobs" => "seeds#spawn_jobs", as: :seed_jobs
    post "seeds/workers" => "seeds#spawn_workers", as: :seed_workers
    post "seeds/hire_workers/:job_id" => "seeds#hire", as: :hire_seed_workers
    post "seeds/shortlist_workers/:job_id" => "seeds#shortlist", as: :shortlist_seed_workers
    post "seeds/attract_workers/:job_id" => "seeds#attract", as: :attract_seed_workers

    get "worker_review/:worker_id" => "reviews#new", as: :new_worker_review
    resources :reviews, only: [:create]
    get "inbound_reviews" => "reviews#index_of", as: :reviews_of
    get "outbound_reviews" => "reviews#index_by", as: :reviews_by

    get "jobs/:id/publish/confirm" => "jobs#publish_confirm", as: :publish_job_confirm
    post "jobs/:id/publish" => "jobs#publish", as: :publish_job
    get "jobs/published" => "jobs#published", as: :published_jobs
    put "jobs/:id/live" => "jobs#live", as: :job_live
    get "jobs/:id/manage" => "jobs#manage", as: :manage_job
    get "jobs/:id/recommend_workers" => "jobs#recommended_workers", as: :job_recommended_workers
    resources :jobs

    get "payments" => "payments#show", as: :payment
    put "payments" => "payments#update", as: :update_payment
  end
  scope "worker", as: "worker", module: "workers" do
    get "/"                  => "overview#index", as: :dashboard
    get "profile_photo"      => "profile_photos#show", as: :profile_photo
    get "profile_photo/edit" => "profile_photos#edit", as: :edit_profile_photo
    get "extra_details"      => "extra_details#show"
    put "extra_details"      => "extra_details#update"

    put "profile_photo" => "profile_photos#update"

    resources :unavailabilities, only: [:index, :create, :update, :destroy]
    resources :job_categories, only: [:index, :create, :destroy]
    resources :skills, only: [:index, :create, :destroy]
    resources :locations, only: [:index, :new, :create, :destroy]
    put "locations/select_all" => "locations#select_all", as: :select_all_locations
    put "locations/reset" => "locations#reset", as: :reset_locations
    resources :previous_employers, only: [:new, :index, :create, :destroy]
    resources :qualifications, only: [:index]
    resources :educations, only: [:new, :create, :destroy]
    resources :certificates, only: [:new, :create, :destroy]
    resources :job_workers, only: [:index]
    resources :notifications, only: [:index, :show]

    get "farmer_review/:farmer_id" => "reviews#new", as: :new_farmer_review
    resources :reviews, only: [:create]
    get "inbound_reviews" => "reviews#index_of", as: :reviews_of
    get "outbound_reviews" => "reviews#index_by", as: :reviews_by

    scope "onboard", as: "onboard" do
      get "job_categories" => "onboard#job_categories"
      get "skills" => "onboard#skills"
    end
  end

  scope "admin", as: "admin", module: "admins" do
    get "farmer/:id/session" => "farmer_sessions#create", as: :create_farmer_session
    get "worker/:id/session" => "worker_sessions#create", as: :create_worker_session
    delete "/farmer/signout" => "farmer_sessions#destroy", as: :destroy_farmer_session
    delete "/worker/signout" => "worker_sessions#destroy", as: :destroy_worker_session
  end

  resources :workers, only: [:show]
  resources :farmers, only: [:show]
  resources :jobs, only: [:show]

  get "job_workers/:job_id" => "job_workers#index", as: :job_workers
  get "job_workers/:id/not_interested" => "job_workers#not_interested", as: :worker_not_interested
  post "job_workers/:job_id/express_interest" => "job_workers#express_interest", as: :worker_express_interest
  post "jobs/:job_id/shortlist" => "job_workers#shortlist", as: :farmer_shortlist_worker
  post "job_workers/:job_worker_id/:transition" => "job_workers#transition", as: :job_worker_transition
  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false
end
