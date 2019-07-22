Rails.application.routes.draw do
  resources :resource_categories, only: [:show, :create, :update, :destroy] do
    resources :resources, only: [:create]
  end

  resources :resources, only: [:show, :update, :destroy]
end
