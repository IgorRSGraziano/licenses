Rails.application.routes.draw do
  root to: "licenses#index"

  resources :licenses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
