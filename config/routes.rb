Rails.application.routes.draw do
  resources :resource_categories, only: [:show, :create, :update, :destroy] do
    resources :resources, only: [:create]
  end

  get 'resource_categories/:resource_category_id/resources', to: 'resources#search'

  resources :resources, only: [:show, :update, :destroy] do
    resources :resource_steps, only: [:create]
    # TODO: list resource steps for resource
  end
  resources :resource_steps, only: [:show, :update, :destroy]
end
