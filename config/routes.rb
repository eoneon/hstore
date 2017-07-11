Rails.application.routes.draw do
  resources :item_types
  resources :items
  root to: 'items#index'
end
