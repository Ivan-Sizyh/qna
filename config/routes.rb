Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: %i[index]
    patch 'select_best_answer', action: :set_best_answer, on: :member
  end
end
