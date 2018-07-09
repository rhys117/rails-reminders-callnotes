Rails.application.routes.draw do
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
  resources :call_notes do
    post '/call_notes' => 'call_notes#index', :as => 'index'
  end

  get '/fetch_correspondence' => 'call_notes#correspondence_categories', as: 'fetch_correspondence'
  get '/fetch_selected_template' => 'call_notes#selected_template', as: 'fetch_selected_template'
  get '/fetch_template_categories' => 'call_notes#template_categories', as: 'fetch_template_categories'
end