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
      patch 'inverse_complete'
    end
  end
  get '/auto_manage', to: 'reminders#auto_manage'
  resources :call_notes do
    post '/call_notes' => 'call_notes#index', :as => 'index'
  end
  get "/fetch_enquiry_templates" => 'call_notes#enquiry_templates', as: 'fetch_enquiry_templates'
  get "/fetch_work_templates" => "call_notes#work_templates", as: 'fetch_work_templates'
  get "/fetch_email_templates" => "call_notes#email_templates", as: 'fetch_email_templates'
  get "/fetch_templates" => "call_notes#templates", as: 'fetch_templates'
  get "/fetch_selected_template" => "call_notes#selected_template", as: 'fetch_selected_template'

  get '/fetch_template_categories' => 'call_notes#template_categories', as: 'fetch_template_categories'
end