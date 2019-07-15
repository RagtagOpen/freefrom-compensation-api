Rails.application.routes.draw do
  resources :resource_categories, only: [:show, :create, :update, :delete]
end
