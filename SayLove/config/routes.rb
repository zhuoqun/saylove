SayLove::Application.routes.draw do

  get '/login' => 'accounts#login'
  get '/faq' => 'accounts#faq'
  get '/settings' => 'accounts#settings'
  post '/settings' => 'accounts#settings_update'

  get "/mobile" => 'mobile#index'

  get '/search/:type/:name' => 'accounts#search'

  get '/notifications' => 'profiles#notifications'

  get '/logout' => 'sessions#destroy'

  match "/auth/:provider/callback" => "sessions#oauth_success"
  match "/auth/failure" => "sessions#oauth_failure"

  resources :letters do
    member do
      get :flower
      get :favorite
    end

    resources :comments, :only => [:create]
  end

  get '/echobox' => 'letters#echobox'
  get '/sentbox' => 'letters#sentbox'
  get '/favorites' => 'letters#favorites'
  get '/write' => 'letters#new'
  get '/recent' => 'letters#index'
  get '/hot' => 'letters#hot'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # different root for logged in/unlogged in users
  root :to => 'welcome#index', :constraints => lambda {|r| r.session[:user_id].nil? }
  root :to => 'letters#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
