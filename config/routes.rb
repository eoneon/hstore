Rails.application.routes.draw do
  resources :item_types
  resources :mounting_types
  resources :certificate_types
  resources :signature_types
  resources :substrate_types
  resources :items do
    collection { post :import }
  end
  resources :value_items do
    collection { post :import }
  end
  resources :artists
  resources :invoices do
    resources :items, except: [:index]
  end
  resources :searches
  root to: 'invoices#index'
end
