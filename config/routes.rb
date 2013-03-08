Tempofreelax::Application.routes.draw do
  resources :player_annual_stats

  resources :player_game_stats

  resources :players

  resources :conference_stats

  resources :stats

  resources :national_ranks

  resources :teams

  resources :conferences

  resources :annual_stats

  resources :game_stats

  resources :games
  
  match 'calendar/:date' => 'games#index'
  match 'teams/page/:page' => 'teams#index'
#  match 'teams/:year/:id' => 'teams#show'
  match 'teams/:id/:year' => 'teams#show'
  match 'overview/:year' => 'annual_stats#index'
  match 'overview/' => 'annual_stats#index'
  match 'conf_stats/:conference_id/:year' => 'conference_stats#index'
  match 'games/:year/page/:page' => 'games#index'
  match 'games/:year' => 'games#index'
  match 'stat/add' => 'stats#new'
  match 'stat/all' => 'stats#index'
  match 'player/:page/' => 'players#index'
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
   root :to => 'annual_stats#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
