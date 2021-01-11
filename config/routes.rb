Rails.application.routes.draw do

  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    devise_for :users, skip: :omniauth_callbacks
    # корень сайта
    root "events#index"

    resources :events do
      resources :comments, only: [:create, :destroy]
      resources :subscriptions, only: [:create, :destroy]
      resources :photos, only: [:create, :destroy]

      post :show, on: :member
    end

    resources :users, only: [:show, :edit, :update]
  end
end
