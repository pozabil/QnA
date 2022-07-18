Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions, only: [:index, :show, :new, :create] do
    resources :answers, only: [:new, :create], shallow: true
  end
end
