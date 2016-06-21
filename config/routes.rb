Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post 'confirm_email', to: 'omniauth_callbacks#confirm_email'
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      delete 'remove_vote'
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: :create, defaults: { commentable: 'answers' }
      member do
        post 'best_answer'
      end
    end
  end

  root 'questions#index'
end
