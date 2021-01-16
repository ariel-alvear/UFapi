Rails.application.routes.draw do
  resources :clients
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  get "/uf/:date", to: 'clients#uf'
  get "/client/:name", to: 'clients#my_requests'
end
