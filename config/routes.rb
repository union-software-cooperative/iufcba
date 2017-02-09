Rails.application.routes.draw do
  
  scope ":locale" do
    devise_for :people, :controllers => { :invitations => 'people/invitations' }
    resources :people, only: [:edit, :update], as: 'profile'
    
    scope ":division_id" do 
      resources :messages 
      resources :comments
      resources :posts
        
      resources :companies, controller: :supergroups, type: 'Company'  do
        member do
          get 'follow'
        end
      end

      resources :unions, controller: :supergroups, type: 'Union' do
        member do
          get 'follow'
        end
      end
      
      resources :people, except: [:new, :show] do # people can only be invited, and edited (no readonly view)
        member do 
          get 'compose_email'
          patch 'send_email'
        end
      end 

      resources :recs do
        member do
          get 'follow'
        end
      end

      get '/public/:filename', to: 'files#get'
      resources :agreements, controller: :recs, type: 'Rec'
    end

    resources :divisions, except: [:show]
    
    resource :help, only: [:show] do
      resource :request_invite, only: [:new, :create], module: :help
    end
    # root "help#show"
    resources :unions, only: [:index], controller: :supergroups, type: 'Union', constraints: {:format => 'json'}, as: 'union_api'
    root "help#show", as: "root_with_locale"
  end
  root "application#pass_to_locale_scope"
  

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
