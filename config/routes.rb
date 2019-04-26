Rails.application.routes.draw do
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
    resources :answers, concerns: [:voteable, :commentable], only: %i[create update destroy], shallow: true do
      patch :make_best, on: :member
    end
  end

  mount ActionCable.server => '/cable'
end
