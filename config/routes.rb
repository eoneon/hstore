Rails.application.routes.draw do
  resources :item_types
  resources :dimension_types
  resources :edition_types
  resources :leafing_types
  resources :remarque_types
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

  # post '/sort_up' => 'categories#sort_up'
  resources :categories do
    collection { post :import }
    # post :sort_up
  end

  resources :invoices do
    resources :items, except: [:index]
  end

  root to: 'invoices#index'
end
