Rails.application.routes.draw do
  root "dashboard#index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  post "dashboard/cart_items/:product_id", to: "dashboard#add_to_cart", as: :dashboard_cart_items
  patch "dashboard/cart_items/:product_id", to: "dashboard#update_cart_item", as: :dashboard_cart_item
  delete "dashboard/cart", to: "dashboard#clear_cart", as: :dashboard_cart
  post "dashboard/cart/whatsapp", to: "dashboard#request_cart_whatsapp", as: :dashboard_cart_whatsapp

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

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
