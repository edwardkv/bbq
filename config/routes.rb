Rails.application.routes.draw do

  devise_for :users
  # корень сайта
  root "events#index"

  resources :events
  resources :users, only: [:show, :edit, :update]
end
