Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  root to: "licenses#index"

  get 'licenses/import', to: 'licenses#import'
  post 'licenses/import', to: 'licenses#import_create'
  put 'licenses/change_status', to: 'licenses#change_status'
  resources :licenses

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  post 'webhook/hotmart', to: 'webhook#hotmart'
end
