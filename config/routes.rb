Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # get '/user' => "pages#admin_home", :as => :user_root
  get '/admin', to: 'pages#admin'
  get '/expired', to: 'pages#expired'

  post 'shorten', to: 'urls#shorten'
  get 'shortened/:id', to: 'urls#shortened'
  get '/s/:short_code', to: 'urls#redirect_link'

  get '/user' => "urls#index", :as => :user_root
  get '/user/urls', to: 'urls#index'
  get '/user/urls/new', to: 'urls#new'
  post '/user/urls/create', to: 'urls#create'
  get '/user/urls/:id', to: 'urls#edit'
  post '/user/urls/:id', to: 'urls#update'
  delete '/user/urls/:id', to: 'urls#delete'
end
