Rails.application.routes.draw do
  devise_for :users

  concern :voteable do
    member do
      patch :upvote
      patch :downvote
    end
  end

  root 'questions#index'

  resources :questions, only: [:index, :show, :new, :create, :update, :destroy], concerns: [:voteable] do
    resources :answers, only: [:create, :update, :destroy], concerns: [:voteable], shallow: true do
      member { patch :mark_as_best }
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :trophies, only: :index
end
