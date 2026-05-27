Rails.application.routes.draw do
  root "dashboard#index"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resource :dashboard, only: :show, controller: :dashboard
  get "kitchen", to: "kitchen#index", as: :kitchen
  resource :settings, only: %i[edit update]

  resources :users
  resources :categories
  resources :products
  resources :customers, only: %i[index show edit update]
  resources :orders do
    member do
      patch :update_status
      patch :cancel
      get :whatsapp
      get :kitchen_whatsapp
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
