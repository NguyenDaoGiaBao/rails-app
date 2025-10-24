Rails.application.routes.draw do
  get "bookings/index"
  get "bookings/create"
  resource :session
  resources :passwords, param: :token
  get "dashboard/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboard#index"

  # get "/players", to:"players#index", as: :players_list
  # get "/players/create", to:"players#new", as: :players_new
  # post "/players", to:"players#create", as: :players_create
  # get "/players/:id", to:"players#show", as: :players_show
  # patch "/players/:id", to: "players#update", as: :players_update
  # delete "/players/:id", to: "players#destroy", as: :players_destroy

  resources :players
  resources :clubs
  resources :users
  resources :tasks
  resources :movies do
    member do
      post :toggle_status
    end

    collection do
      post :bulk_actions
    end
  end
  resources :screens
  resources :showtimes
  resources :bookings do
    member do
      post :confirm
      post :cancel
    end
  end

  get "/", to: "dashboard#index"
  get "/login", to: "auth#login"
  post "/login", to: "auth#create", as: :auth_login
  get "/logout", to: "auth#logout", as: :auth_logout
  get "/register", to: "auth#register", as: :register
  post "/register", to: "auth#store", as: :store
  put "deactive_account/:id", to: "users#deactive_account", as: :deactive_account
  delete "account/:id", to: "users#delete_my_account", as: :delete_my_account
  get "profile/:id/change-password", to: "users#password", as: :profile_password
  patch "profile/:id/change-password", to: "users#update_password", as: :update_my_password
  put "tasks/:id/done", to: "tasks#update_is_done", as: :update_is_done


  get "profile/:user_name", to: "profile#show", as: :profile
  patch "profile/:user_name", to: "profile#update", as: :update_profile

  # Player login
  get  "/front-login", to: "sessions#new", as: :player_login
  post "/front-login", to: "sessions#create"
  delete "/front-logout", to: "sessions#destroy", as: :player_logout
  namespace :front do
    get "booking", to: "bookings#index"
    get "bookings/new",  to: "bookings#new"
    post "booking", to: "bookings#create"

    resources :movies, only: [:index, :show]
  end

end
