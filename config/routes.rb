Easytiger::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action
  match 'auth' => 'application#auth'
  match 'feed' => 'home#feed'
  match 'feed/next_page/:max_id' => 'home#feed_page_from_max_id'
  match 'login' => 'application#login'
  match 'logout' => 'application#logout', :as => :logout
  match 'popular' => 'home#popular', :as => :popular
  match 'photos/:id' => 'photos#show', :as => :media
  match 'photos/:id/like' => 'photos#like', :as => :like_media
  match 'photos/:id/unlike' => 'photos#unlike', :as => :unlike_media
  match 'photos/:id/comment' => 'photos#comment', :as => :comment_media
  match 'photos/:id/load/likes' => 'photos#lazy_load_likes'
  match 'photos/:id/load/comments' => 'photos#lazy_load_comments'
  match 'users/:username' => 'users#show', :as => :profile
  match 'users/:id/next_page/:max_id' => 'users#feed_page_from_max_id'

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
  # root :to => 'welcome#index'
  root :to => "home#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
