Rails.application.routes.draw do
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      omniauth_callbacks: 'users/omniauth_callbacks'
    }

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root
  root "rails/health#show"

  # Profile
  resource :profile, only: [:show, :update]

  # Payments
  post '/create-checkout', to: 'payments#create_checkout'
  post "/webhooks/stripe", to: "webhooks#stripe"

  # Admin
  namespace :admin do
    resources :users, only: [:index]
  end
end