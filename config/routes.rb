Rails.application.routes.draw do
  get 'launch_controller/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }

  get 'dashboard/index'

  #get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  constraints(Subdomain) do
    get "/" => "bulls/home#index", as: "home", :constraints => { :subdomain => /^(?!www)(\w+)/ }
    resources :dashboard, :controller => "bulls/dashboard"
  end

  root 'home#index'

  resource :dashboard do
    resources :launch, :controller => "dashboard/launch"
    resources :plans, :controller => "dashboard/plans"
    resources :cards, :controller => "dashboard/cards"
    resources :members, :controller => "dashboard/members" do
      collection do
        get :count, defaults: { format: 'json' }
      end
    end
    resources :subscriptions, :controller => "dashboard/subscriptions" do
      collection do
        get :count, defaults: { format: 'json' }
      end
      member do
        post :change, defaults: { format: 'json' }
      end
    end
    resources :payments, :controller => "dashboard/payments" do
      collection do
        get :count, defaults: { format: 'json' }
      end
      member do
        post :refund, defaults: { format: 'json' }
      end
    end
    resources :account, :controller => "dashboard/account" do
      collection do
        post :upload_logo, defaults: { format: 'json' }
      end
      member do
        post :change_password, defaults: { format: 'json' }
        post :change_subdomain, defaults: { format: 'json' }
        post :upgrade_plan, defaults: { format: 'json' }
      end
    end
  end

  resource :bulls do
    resources :plans, :controller => "bulls/plans"
    resources :subscriptions, :controller => "bulls/subscriptions" do
      member do
        post :change, defaults: { format: 'json' }
      end
    end
  end

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
  mount API::Base => '/api'
  mount StripeEvent::Engine => '/stripe-events'
end
