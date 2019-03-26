Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :attachments, only: :destroy
  resources :badges, only: :index

  resources :questions do
    resources :answers, only: %i[create update destroy], shallow: true do
      patch :make_best, on: :member
    end
  end
end
