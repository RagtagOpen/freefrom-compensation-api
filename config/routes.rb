Rails.application.routes.draw do
  post 'user_tokens' => 'user_token#create'
  get '/users/current'  => 'users#current'

  resources :resource_categories, only: [:show, :create, :update, :destroy] do
    resources :resources, only: [:create]
    resources :mindsets, only: [:create]
  end

  get 'resource_categories/:resource_category_id/resources', to: 'resources#search'

  resources :resources, only: [:show, :update, :destroy] do
    resources :resource_steps, only: [:create]
    resources :resource_links, only: [:create]

    get 'resource_steps', on: :member, to: 'resources#steps'
    get 'resource_links', on: :member, to: 'resources#links'
  end

  resources :mindsets, only: [:show, :update, :destroy, :index]
  resources :resource_steps, only: [:show, :update, :destroy]
  resources :resource_links, only: [:show, :update, :destroy]

  resources :quiz_questions, only: [:show, :create, :update, :destroy, :index] do
    resources :quiz_responses, only: :create
  end

  resources :quiz_responses, only: [:show, :update, :destroy]
end
