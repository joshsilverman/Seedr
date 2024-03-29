Quizlet::Application.routes.draw do

  devise_for :users

  match "cards/audit" => "scorecards#audit"
  match "handles/:handle_id/audit" => "scorecards#audit"
  get "handles/:handle_id/reaudit" => "scorecards#reaudit"
  match "groups/:group_id/audit" => "scorecards#audit"
  match "decks/:deck_id/audit" => "scorecards#audit"
  resources :scorecards
  
  resources :users

  match "handles/:id/export" => "handles#export"
  resources :handles

  match "decks/new/:handle_id" => "decks#new"
  match "decks/:id/sort" => "decks#sort"
  resources :decks

  resources :groups
  post "groups/:id/preview" => "groups#preview"

  match "cards/:id/group/:group_id" => "cards#group"
  match "cards/:id/ungroup" => "cards#ungroup"
  resources :cards


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
  root :to => 'handles#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
