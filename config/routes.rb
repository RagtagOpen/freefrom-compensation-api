Rails.application.routes.draw do
  devise_for :users
  post 'user_tokens' => 'user_token#create'
  get '/users/current'  => 'users#current'

  resources :resource_categories, only: [:index, :show, :create, :update, :destroy] do
    resources :resources, only: [:create]
    resources :mindsets, only: [:create]
  end

  get 'mindsets/:mindset_id/resources', to: 'resources#search'
  get 'resource_categories/:slug/resources', to: 'resources#search_by_category'

  resources :resources, only: [:show, :update, :destroy]
  resources :mindsets, only: [:show, :update, :destroy, :index]

  resources :quiz_questions, only: [:show, :create, :update, :destroy, :index] do
    resources :quiz_responses, only: :create
    get 'quiz_responses', on: :member, to: 'quiz_questions#responses'
  end

  resources :quiz_responses, only: [:show, :update, :destroy]

  root to: 'admin#index'
end
