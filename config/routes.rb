Myflix::Application.routes.draw do
  get "home", to: "videos#index"
  get "my_queue", to: "queue_items#index"

  resources :videos, only: :show do
    resources :reviews, only: [:create]
    collection do
      post "search"
    end
  end
  resources :queue_items, only: [:create, :destroy]
  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :relationships, only: [:destroy, :create]
  resources :password_tokens, only: [:create, :show]
  resources :invitations, only: [:create]
  namespace :admin do
    resources :videos, only: [:new, :create]
  end

  get "people", to: "relationships#index"
  post "update_queue", to: "queue_items#update_queue"
  get "register", to: "users#new"
  get "register/:token", to: "users#new_with_invitation_token", as: "register_with_token"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_out", to: "sessions#destroy"
  get 'ui(/:action)', controller: 'ui'
  root to: "pages#index"
  get "forgot_password", to: "password_tokens#new"
  get "invalid_token", to: "pages#invalid_token"
  post "update_password", to: "password_tokens#update"
  get "invite", to: "invitations#new"
end
