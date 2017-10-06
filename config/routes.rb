Rails.application.routes.draw do
  resources :item_types
  resources :mounting_types
  resources :certificate_types
  resources :signature_types
  resources :substrate_types
  resources :categories
  resources :artists
  resources :searches

  resources :items do
    collection { post :import }
  end
  resources :value_items do
    collection { post :import }
  end

  resources :categories do
    collection { post :import }
  end

  resources :invoices do
    resources :items, except: [:index]
  end

  root to: 'invoices#index'
end
