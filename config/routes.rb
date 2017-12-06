Rails.application.routes.draw do
  resources :item_types
  resources :dimension_types
  resources :edition_types
  resources :certificate_types
  resources :signature_types
  resources :substrate_types
  resources :reserve_types
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
    resources :items, except: [:index] do
      member do
        get :create_skus
      end
    end
    #resources :skus, only: [:create]
  end

  root to: 'invoices#index'
end
