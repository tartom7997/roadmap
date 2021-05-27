Rails.application.routes.draw do

  get 'categories/index'
  get 'categories/edit'
  get 'sessions/new'
  root 'static_pages#home'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/signup_sns',  to: 'users#new_sns'
  post '/signup_sns',  to: 'users#create_sns'
  patch '/signup_sns',  to: 'users#create_sns'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # get 'auth/:provider/callback', to: 'sessions#create'
  # get 'auth/failure', to: redirect('/')
  get 'auth/:provider/callback', to: 'users#new_sns'
  get 'auth/failure', to: redirect('/')
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'email_resets/new'
  get 'email_resets/edit'
  post '/users/:user_id/roadmaps/new', to: 'roadmaps#create'
  patch '/users/:user_id/roadmaps/:id/edit', to: 'roadmaps#update'
  post '/users/:user_id/roadmaps/:roadmap_id/steps', to: 'steps#create'
  patch '/users/:user_id/roadmaps/:roadmap_id/steps/:id/edit', to: 'steps#update'
  get  '/users/:user_id/roadmaps/all', to: 'roadmaps#all'
  get  '/users/:user_id/roadmaps/:roadmap_id/steps/:step_id/posts/all', to: 'posts#all'
  patch '/users/:user_id/roadmaps/:roadmap_id/steps/:step_id/posts/:id/edit', to: 'posts#update'
  get '/roadmap/hashtag/:name' => 'roadmaps#hashtag'
  get '/roadmap/hashtag' => 'roadmaps#hashtag'
  get '/post/hashtag/:name' => 'posts#hashtag'
  get '/post/hashtag' => 'posts#hashtag'

  resources :users do
    member do
      get :following, :followers
    end
    # https://techblog.kyamanak.com/entry/2017/08/12/155914
    # collection do
    #   get :search
    # end
    resources :roadmaps do
      collection do
        get   :all
      end
      member do
        patch :learnig
      end
      resources :steps do
        resources :posts do
          collection do
            get   :all
          end
        end
      end
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :email_resets,        only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :roadmaps,            only: [:index]
  resources :posts,               only: [:index]
  resources :categories,          except: [:new, :show]
end
