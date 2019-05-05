require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[show create update destroy], shallow: true
      end
    end
  end

  concern :voteable do
    member do
      post :up_rating
      delete :un_rating
      post :down_rating
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :attachments, only: :destroy
  resources :badges, only: :index

  resources :questions, concerns: [:voteable, :commentable] do
    member do
      post :subscribe
      delete :unsubscribe
    end
    resource :subscription, only: %i[create destroy]
    resources :answers, concerns: [:voteable, :commentable], only: %i[create update destroy], shallow: true do
      patch :make_best, on: :member
    end
  end

  get :search, to: 'searches#index'

  mount ActionCable.server => '/cable'
end
