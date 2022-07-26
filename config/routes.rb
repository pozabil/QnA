Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions, only: [:index, :show, :new, :create, :destroy] do
    resources :answers, only: [:create], shallow: true
  end
end
