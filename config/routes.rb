Rails.application.routes.draw do
  # Root path
  root "pages#home"
  get "pages/home"

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
    resources :projects, only: [:index]
  end

  # Projects management
  resources :projects do
    resources :invitations, only: [:new, :create]
    resources :tasks
    delete 'remove_user', on: :member           # added becoz we are deleting a user from a proj not the whole proj 
  end

  # Super Admin Dashboard
  namespace :super_admin do
    get 'dashboard', to: 'dashboards#index', as: 'dashboard'
    delete 'users/:id', to: 'dashboards#destroy_user', as: 'destroy_user'
  end

  # Development tools
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  # Active Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end