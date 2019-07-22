Rails.application.routes.draw do
  resources :resource_categories, only: [:show, :create, :update, :destroy]
  resources :resources, only: [:show, :create, :update, :destroy]
end
