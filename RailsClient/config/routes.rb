Rails.application.routes.draw do

  resources :part_wrappages

  resources :wrappages do
    member do
      get 'part_wrappages'
    end

    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
      match :import_parts, to: :import_parts, via: [:get, :post]
      match :import_stock, to: :import_stock, via: [:get, :post]
    end
  end

  resources :back_part_items do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :back_parts do
    member do
      get 'stock_move'
      get 'back_part_items'
    end

    collection do
      post :print
      get :search
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :package_types

  resources :permission_group_items do
    collection do
      get :search
    end
  end

  resources :user_permission_groups do
    collection do
      get :search
    end
  end

  resources :permissions do
    collection do
      get :search
    end
  end

  resources :permission_groups do
    collection do
      get :search
      match :add_permissions, to: :add_permissions, via: [:get, :post]
      get :permission_details
    end
  end

  resources :tenants do
    resources :part_clients do
      collection do
        get :search
        match :import, to: :import, via: [:get, :post]
      end
    end
  end

  resources :part_clients

  resources :movement_sources do
    collection do
      get :search
    end
  end

  resources :operation_logs do
    collection do
      get :search
    end
  end

  resources :storage_operation_records do
    collection do
      get :search
    end
  end

  resources :movement_lists do
    collection do
      get :search
      get :exports
    end
    member do
      get 'movement_sources'
    end
  end

  resources :scrap_list_items do
    collection do
      match :import, to: :import, via: [:get, :post]
      get :search
    end
  end

  get 'scrap_lists/reports', to: 'scrap_lists#reports'

  resources :scrap_lists do
    member do
      get 'scrap_list_items'
      get :scrap

    end

    collection do
      match :import, to: :import, via: [:get, :post]
    end
  end

  resources :inventory_lists do
    member do
      get 'inventory_list_items'
      get :discrepancy
    end

    collection do
      get :export_total
      get :export_by_whouse
      get :disable_enable_storage
    end
  end

  resources :inventory_list_items do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end
    member do
      get :export_list_detail
      get :export_list_total
      get :lock_unlock_list
      get :store_list
      get :unstore_list
    end
  end

  resources :storages do
    collection do
      get :search
      get :panel
      get :search_storage
    end
  end


  resources :regex_categories do
    collection do
      get :regex_template
    end
  end
  resources :led_states
  resources :sys_configs do
    collection do
      match :jiaxuan_extra, to: :jiaxuan_extra, via: [:get, :post]
    end
  end
  resources :logistics_containers do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
    end

    member do
      get :export
      get :stock_move
    end
  end
=begin

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_sys } do
    mount Sidekiq::Web => '/sidekiq'
  end
=end

  resources :order_items do
    collection do
      get :search
    end
  end
  resources :pick_items do
    collection do
      get :search
    end
  end

  resources :pick_lists do
    collection do
      post :print
      get :search
      # post :export
    end
  end
  post 'pick_lists/export', to: 'pick_lists#export'

  mount ApplicationAPI => '/api'
  root :to => "welcome#index"

  devise_for :users, :controllers => {:registrations => "users/registrations"}, path: "auth", path_names: {sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in'}

  resources :deliveries do
    collection do
      #match :import, to: :import, via: [:get, :post]
      match :generate, to: :generate, via: [:get, :post]
      match :generate_jiaxuan, to: :generate_jiaxuan, via: [:get, :post]
      match :receive, to: :receive, via: [:get, :post]
      get :search
    end
    member do
      get :forklifts
    end
  end


  resources :files do
    collection do
      get :download
    end
  end

  resources :orders do
    collection do
      get :panel
      get :panel_list
      get :pick_panel
      get :search
      get :items
      get :pickitems
      get :filters
      get :filt
      get :picklists
      match :import, to: :import, via: [:get, :post]
      post :handle
    end
    member do
      get :order_items
    end
  end

  resources :packages do
    collection do
      get :search
      get :download_quantity
    end
  end

  resources :forklifts do
    collection do
      get :search
    end
    member do
      get :packages
    end
  end

  get 'parts/import_positions', to: 'parts#import_positions'
  get 'parts/template_position', to: 'parts#template_position'
  get 'parts/download_positions', to: 'parts#download_positions'
  post 'parts/do_import_positions', to: 'parts#do_import_positions'

  resources :n_storages do
    collection do
      get :search
      match :import, to: :import, via: [:get, :post]
      match :move, to: :move, via: [:get, :post]
      match :group, to: :group, via: [:get, :post]
      get :total
      get :container
      # get :panel
      # get :search_storage
      get :summary
      get :exports
    end

  end

  resources :movements do
    collection do
      match :misoperation, to: :misoperation, via: [:get, :post]
      get :search
    end
  end

  [:locations, :whouses, :parts, :positions, :part_positions, :deliveries, :forklifts,
   :packages, :part_types, :pick_item_filters, :orders, :modems, :leds].each do |model|
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

  resources :users do
    collection do
      post :do_import
      get :import
      get :download
      get :template
      get :search
      match :permission_groups, to: :permission_groups, via: [:get, :post]
    end
  end

  delete '/parts/delete_position/:id', to: 'parts#delete_position'

  get 'reports/discrepancy', to: 'reports#discrepancy'
  get 'reports/orders_report', to: 'reports#orders_report'
  get 'reports/reports', to: 'reports#reports'
  post 'reports/upload_file', to: 'reports#upload_file'
  get 'reports/safe_stock_report', to: 'reports#safe_stock_report'

  get 'notifications', to: 'notifications#index'
  get 'notifications/orderbus', to: 'notifications#orderbus'

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
      get 'destinations'
      post :add_destination
      delete 'remove_destination/:destination_id', to: :remove_destination, as: 'remove_destination'
      post 'set_default_destination/:destination_id', to: :set_default_destination, as: 'set_default_destination'
    end
  end

  resources :whouses do
    member do
      get 'positions'
    end
  end

  resources :positions do
    member do
      get 'parts'
    end
  end

  resources :syncs do
    collection do
      post :reload
    end
  end

  resources :regexes do
    collection do
      post :save
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
