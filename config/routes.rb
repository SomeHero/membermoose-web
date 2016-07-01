Rails.application.routes.draw do
  get 'launch_controller/index'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_scope :user do
    post "/users/sign_up" => "dashboard/users/registrations#create", as: "new_user_registration" 
  end
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks",
        :registrations => "dashboard/users/registrations",
        :sessions => "dashboard/users/sessions",
        :passwords => "dashboard/users/passwords" }

  get 'dashboard/index'

  #get 'home/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  constraints(Subdomain) do
    get "/" => "bulls/home#index", as: "home", :constraints => { :subdomain => /^(?!www)(\w+)/ }
    get "/subscribe/:guid" => "bulls/home#index", as: "subscribe", :constraints => { :subdomain => /^(?!www)(\w+)/ }
  end

  root 'home#index'

  resource :dashboard do
    resources :launch, :controller => "dashboard/launch" do
      collection do
        resources :upload_logo, :controller => "dashboard/launch"
        resources :setup_subdomain, :controller => "dashboard/launch"
        resources :plan, :controller => "dashboard/launch"
        resources :connect_stripe, :controller => "dashboard/launch"
        resources :upgrade, :controller => "dashboard/launch"
      end
    end
    resources :plans, :controller => "dashboard/plans" do
      collection do
        resources :create, :controller => "dashboard/plans"
        resources :delete, :controller => "dashboard/plans"
        resources :share, :controller => "dashboard/plans"
        post :get_stripe_plans, defaults: { format: 'json' }
        post :import_stripe_plans, defaults: { format: 'json' }
      end
    end
    resources :cards, :controller => "dashboard/cards" do
      collection do
        resources :destroy, :controller => "dashboard/cards"
        resources :update, :controller => "dashboard/cards"
      end
    end
    resources :billing, :controller => "dashboard/cards"
    resources :members, :controller => "dashboard/members" do
      collection do
        get :count, defaults: { format: 'json' }
        resources :add_card, :controller => "dashboard"
        resources :update_card, :controller => "dashboard"
        resources :delete_card, :controller => "dashboard"
        resources :next_invoice, :controller => "dashboard"
      end
    end
    resources :subscriptions, :controller => "dashboard/subscriptions" do
      collection do
        resources :unsubscribe, :controller => "dashboard"
        resources :change_plan, :controller => "dashboard"
        resources :hold, :controller => "dashboard"
        resources :unhold, :controller => "dashboard"
        get :count, defaults: { format: 'json' }
      end
      member do
        post :change, defaults: { format: 'json' }
        post :hold, defaults: { format: 'json' }
        post :unhold, defaults: { format: 'json' }
      end
    end
    resources :payments, :controller => "dashboard/payments" do
      collection do
        resources :refund, :controller => "dashboard"
        get :count, defaults: { format: 'json' }
      end
      member do
        post :refund, defaults: { format: 'json' }
      end
    end
    resources :account, :controller => "dashboard/account" do
      resources :my_subscriptions, :controller => "dashboard/account/my_subscriptions"
      resources :cards, :controller => "dashboard/account/cards", :defaults => { :format => 'json' }
      resources :upload_logo, :controller => "dashboard/account"
      collection do
        post :upload_logo, defaults: { format: 'json' }
      end
      member do
        post :change_password, defaults: { format: 'json' }
        post :change_subdomain, defaults: { format: 'json' }
        post :upgrade_plan, defaults: { format: 'json' }
      end
    end
    resources :my_subscriptions, :controller => "dashboard/account/my_subscriptions" do
      resources :unsubscribe, :controller => "dashboard/account"
      resources :upgrade, :controller => "dashboard/account"
      collection do
        post :upgrade_plan, defaults: { format: 'json' }
        post :change_plan, default: { format: 'json'}
      end
      member do
        post :change, defaults: { format: 'json' }
      end
    end
    resource :bulls do
      collection do
        resources :plans, :controller => "dashboard/bulls/plans", defaults: { format: 'json' }
      end
    end
  end

  resource :bulls do
    resources :plans, :controller => "bulls/plans", defaults: { format: 'json' }
    resources :cards, :controller => "bulls/cards", defaults: { format: 'json' }
    resources :subscriptions, :controller => "bulls/subscriptions", defaults: { format: 'json' } do
      member do
        post :change
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
