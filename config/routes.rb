Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  resources :urls

  get '/admin', to: 'pages#admin'
  get '/expired', to: 'pages#expired'

  post 'shorten', to: 'urls#shorten'
  get 'shortened/:id', to: 'urls#shortened'

  get '/:short_code', to: 'urls#redirect_link'
end
