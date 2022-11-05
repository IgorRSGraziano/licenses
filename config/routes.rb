Rails.application.routes.draw do
  root to: "licenses#index"

  get 'licenses/import', to: 'licenses#import'
  post 'licenses/import', to: 'licenses#import_create'
  resources :licenses

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
