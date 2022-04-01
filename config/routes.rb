Rails.application.routes.draw do
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
end
