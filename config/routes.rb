Rails.application.routes.draw do
  post 'user_tokens' => 'user_token#create'
  get '/users/current'  => 'users#current'

  resources :resource_categories, only: [:show, :create, :update, :destroy] do
    resources :resources, only: [:create]
    resources :mindsets, only: [:create]
  end

  get 'mindsets/:mindset_id/resources', to: 'resources#search'

  resources :resources, only: [:show, :update, :destroy]
  resources :mindsets, only: [:show, :update, :destroy, :index]

  resources :quiz_questions, only: [:show, :create, :update, :destroy, :index] do
    resources :quiz_responses, only: :create
    get 'quiz_responses', on: :member, to: 'quiz_questions#responses'
  end

  resources :quiz_responses, only: [:show, :update, :destroy]
end
