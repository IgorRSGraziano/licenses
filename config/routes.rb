Rails.application.routes.draw do
  resources :links
  resources :parameters
  resources :clients
  resources :payments, except: [:index]
  resources :customers
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root to: "licenses#index"

  get 'licenses/import', to: 'licenses#import'
  post 'licenses/import', to: 'licenses#import_create'
  put 'licenses/change_status', to: 'licenses#change_status'
  put 'licenses/activate', to: 'licenses#activate'
  put 'licenses/inactivate', to: 'licenses#inactivate'
  get 'licenses/inactivate', to: 'licenses#inactivate'
  get 'licenses/status', to: 'licenses#status'
  resources :licenses

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'

  get 'account', to: 'user#edit'
  put 'account', to: 'user#update', as: 'user'

  post 'webhook/hotmart/:client_token', to: 'webhook#hotmart', as: 'webhook_hotmart'
  post 'webhook/asaas/:client_token', to: 'webhook#asaas', as: 'webhook_asaas'
end
