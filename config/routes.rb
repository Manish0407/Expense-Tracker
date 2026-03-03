Rails.application.routes.draw do
  get 'payments/new'
  get 'payments/create'
  get 'dashboards/show'
  get 'expenses/new'
  get 'expenses/create'
  get 'expenses/index'
  get 'expenses/show'
  # get 'users/index'
  # get 'users/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  # root "users#index"
  root "dashboards#show"
  resources :users, only: [:index, :show]

  resources :expenses, only: [:new, :create, :index, :show]
  resources :payments, only: [:new, :create]
  get "/admin/clear_all_data", to: "admin#clear_all_data"
end
