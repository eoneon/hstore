Rails.application.routes.draw do
  resources :item_types
  resources :items
  resources :searches
  root to: 'items#index'
end
