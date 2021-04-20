Rails.application.routes.draw do

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

  resources :users do
    member do
      get :following, :followers
    end
    # https://techblog.kyamanak.com/entry/2017/08/12/155914
    # collection do
    #   get :search
    # end
    resources :roadmaps do
      member do
        patch :learnig
      end
    end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :email_resets,        only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :roadmaps,            only: [:index]
end
