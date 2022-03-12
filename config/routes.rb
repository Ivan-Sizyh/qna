Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    resources :answers, except: %i[index] do
      delete 'delete_attached_file', action: :delete_attached_file, on: :member
    end
    patch 'select_best_answer', action: :set_best_answer, on: :member
    delete 'delete_attached_file', action: :delete_attached_file, on: :member
  end

  resources :files, only: :destroy
end
