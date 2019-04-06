Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  concern :voteable do
    member do
      post :up_rating
      delete :un_rating
      post :down_rating
    end
  end

  resources :attachments, only: :destroy
  resources :badges, only: :index

  resources :questions, concerns: [:voteable] do
    resources :answers, concerns: [:voteable], only: %i[create update destroy], shallow: true do
      patch :make_best, on: :member
    end
  end
end
