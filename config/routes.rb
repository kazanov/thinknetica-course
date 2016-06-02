Rails.application.routes.draw do
  devise_for :users

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
