Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      member { patch :mark_as_best }
    end
  end
end
