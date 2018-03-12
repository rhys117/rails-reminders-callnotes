Rails.application.routes.draw do
  root   'static_pages#home'
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
  resources :call_notes
  get "/fetch_enquiry_templates" => 'call_notes#enquiry_templates', as: 'fetch_enquiry_templates'
  get "/fetch_work_templates" => "call_notes#work_templates", as: 'fetch_work_templates'
  get "/fetch_email_templates" => "call_notes#email_templates", as: 'fetch_email_templates'
  get "/fetch_selected_template" => "call_notes#selected_template", as: 'fetch_selected_template'
end