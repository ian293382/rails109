Rails.application.routes.draw do
  devise_for :users
  resources :groups do
    member do
      post :Join
      post :quit
    end
    resources :posts
  end
  root 'groups#index'
end
