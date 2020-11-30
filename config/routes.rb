Rails.application.routes.draw do
  # корень сайта
  root "events#index"

  resources :events

  resources :users, only: [:show, :edit, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
