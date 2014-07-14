Rails.application.routes.draw do
  resources :regexes

  mount ApplicationAPI => '/api'
  root :to => "welcome#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}, path: "auth", path_names: {sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in'}

  resources :deliveries do
    collection do
      match :import, to: :import, via: [:get, :post]
      get :search
    end
    member do
      get :export
    end
  end

  resources :packages

  resources :forklifts

  get 'parts/import_positions', to: 'parts#import_positions'
  get 'parts/template_position', to: 'parts#template_position'
  get 'parts/download_positions', to: 'parts#download_positions'
  post 'parts/do_import_positions', to: 'parts#do_import_positions'

  [:locations, :whouses, :parts, :positions, :part_positions, :users, :deliveries].each do |model|
    resources model do
      collection do
        post :do_import
        get :import
        get :download
        get :template
        get :search
      end
    end
  end

  resources :labels do
    collection do
      post :upload_file
      get :get_config
      get :get_config_hash
      get :get_config_version
    end
  end

  resources :locations do
    member do
      get 'users'
      get 'whouses'
    end
  end

  resources :whouses do
    member do
      get 'positions'
    end
  end

  resources :syncs do
    collection do
      post :reload
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
