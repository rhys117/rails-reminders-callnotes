Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  post "/graphql", to: "graphql#execute"
  root   'reminders#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post   '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users
  resources :quick_notes
  resources :reminders do
    member do
      patch 'mark_complete'
      put   'mark_incomplete'
    end
  end

  get '/auto_manage', to: 'reminders#auto_manage'
  get '/call_notes_v2' => 'call_notes#version_two'

  get '/call_notes/new' => 'call_notes#new', as:'new_call_note'
  get '/call_notes' => 'call_notes#index'
  post '/call_notes' => 'call_notes#create', as: 'create_call_note'

  get '/fetch_correspondence' => 'call_notes#correspondence_categories', as: 'fetch_correspondence'
  get '/fetch_selected_template' => 'call_notes#selected_template', as: 'fetch_selected_template'
  get '/fetch_template_categories' => 'call_notes#template_categories', as: 'fetch_template_categories'
end