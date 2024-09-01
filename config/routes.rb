Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :admin do
    root :to => "orders#index"
    get "sponsors", to: "sponsors#index"

    resources :orders, only: [:index, :edit, :update]
    resources :users
  end

  namespace :api do
    post "fail", to: "payments#fail"
    get "success", to: "payments#success"
    post "result", to: "payments#result"
  end

  get "buy", to: "home#buy"
  get "sponsor", to: "home#sponsor"
  post "become_sponsor", to: "home#become_sponsor"
  post "make_purchase", to: "home#make_purchase"
  get "payment_form", to: "home#payment_form"

  # Defines the root path route ("/")
  root "home#index"
end
