Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

  root to: 'questions#index'

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
