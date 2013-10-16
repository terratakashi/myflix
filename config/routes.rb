Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  root to: "users#index"
  get "home", to: "videos#index"

  resources :videos, only: :show do
    collection do
      post "search"
    end
  end
  resources :categories, only: [:show, :index]
  resources :users, only: [:index, :new, :create]

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_out", to: "sessions#destroy"
end
