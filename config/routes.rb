Rails.application.routes.draw do
 
  # Devise routes with custom controllers
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # Custom invitation routes
  get '/accept_invite', to: 'users/invitations#accept_invite', as: :accept_invite
  post '/register_from_invite', to: 'users/invitations#register_from_invite', as: :register_from_invite

  # Company profile creation
  resources :companies, only: [:new, :create, :show, :update] do
    resources :projects, only: [:index, :show, :new, :create]
    member do
      delete "remove_user/:user_id", to: "companies#remove_user", as: :remove_user
    end
  end

  # Projects management
  resources :projects do
    resources :invitations, only: [:new, :create]
    resources :tasks do
      resources :comments, only: [:create, :edit, :update, :destroy]
      patch :update_status, on: :member
    end
    delete 'remove_user', on: :member           # added becoz we are deleting a user from a proj not from the db account of user 
  end

  # Super Admin Dashboard namespace
  namespace :super_admin do
    get 'dashboard', to: 'dashboards#index', as: 'dashboard'
    delete 'users/:id', to: 'dashboards#destroy_user', as: 'destroy_user'
  end

  # Development tools
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # root route
  root "pages#home"

  #wildcard/catch-all route 
  get '*unmatched_route', to: 'application#not_found'

end