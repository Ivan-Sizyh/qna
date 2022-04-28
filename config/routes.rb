require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  concern :votable do
    member do
      post :vote
      delete :unvote
    end
  end

  devise_for :users
  root to: 'questions#index'

  resources :questions, concerns: [:votable], defaults: { votable: 'questions' } do
    resources :answers, shallow: true, concerns: [:votable], except: %i[index], defaults: { votable: 'answers' }
    patch 'select_best_answer', action: :set_best_answer, on: :member
  end

  resources :files, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  resources :comments, only: :create
  resource :subscriptions, only: %i[create destroy]

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
end
