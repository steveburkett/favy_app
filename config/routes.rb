FavyApp::Application.routes.draw do

  resources :listships

  resources :friendships
  match 'friendships/approve' => 'friendships#approve'
  match 'friendships/ignore' => 'friendships#ignore'

  #devise_for :users, :controllers => { }
  devise_for :users, :controllers => { :registrations => "registrations",:omniauth_callbacks => "users/omniauth_callbacks"  }

  match "users/:id" => 'users#show', :as => "user"
  match "users" => 'users#index'
  match "users/:id/friends" => 'users#friends', :as => "friends"
  get 'users/:id/tags/:tag', to: 'users#show', as: :tag
  match "users/set_default/:id" => "users#set_default", as: :set_default

  match "search" => "users#search"

  resources :lists
  match "lists/create_popup" => 'lists#create_popup'
  match "lists/change_privacy" => "lists#change_privacy"
  match "lists/sort" => 'lists#sort'

  resources :items
  match "items/add" => 'items#add'

  resources :comments

  get "static_pages/home"
  match "sign_up" => "static_pages#sign_up", as: :sign_up
  match "sign_in" => "static_pages#sign_in", as: :sign_in

  match 'main' => 'dashboard#main'

  resources :locations

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'static_pages#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
