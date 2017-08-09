Rails.application.routes.draw do
  resources :item_types
  resources :mounting_types
  resources :certificate_types
  resources :signature_types
  resources :items
  resources :artists
  resources :searches
  root to: 'items#index'
end
