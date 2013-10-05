Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "ui#index"
  get "home", to: "videos#home"
  
  resources :videos, only: :show  
  resources :categories, only: [:show, :index]
end
