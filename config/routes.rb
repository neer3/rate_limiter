Rails.application.routes.draw do
  get 'token_bucket/show/:user_id', to: 'token_bucket#show'
  post 'token_bucket/max_token/:user_id/:max_token', to: 'token_bucket#update_max_token'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
