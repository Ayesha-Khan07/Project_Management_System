Rails.application.routes.draw do
  get "companies/new"
  get "companies/create"
  get "companies/show"
  get "registrations/new_ceo"
  get "registrations/create_ceo"

  # Defines the root path
  root "pages#home"
  get "pages/home"

  #skip default route of devise gem 
  devise_for :users, skip: [ :registrations ]

  get  "/ceo_signup", to: "registrations#new_ceo",    as: :new_ceo_signup
  post "/ceo_signup", to: "registrations#create_ceo", as: :create_ceo_signup
  
  # login path
  match "/ceo_login", to: "registrations#login_ceo", via: [ :get, :post ], as: :login_ceo

  # Company profile creation (after signup)
  resources :companies, only: [ :new, :create, :show, :update ] do
    resources :projects, only: [:index]
  end

  #projects maagement
  resources :projects do
    resources :invitations, only: [:new, :create]
    resources :tasks
  end

  # Routes for accepting the invitation
  get '/accept_invite', to: 'registrations#accept_invite', as: :accept_invite
  post '/register_from_invite', to: 'registrations#register_from_invite', as: :register_from_invite

  if Rails.env.development?
  mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end



  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #project path
  resources :projects

end
