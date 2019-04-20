Rails.application.routes.draw do
  get 'motorbikes/index'
  get 'motorbikes/new'
<<<<<<< HEAD
  get 'motorbikes/create'
=======
>>>>>>> origin/master
  get 'motorbikes/listing'
  get 'motorbikes/pricing'
  get 'motorbikes/photo_upload'
  get 'motorbikes/location'
  get 'motorbikes/update'
  get 'pages/about'
  get 'pages/owners'
  get 'pages/renters'
  root 'pages#home'

  devise_for :users,
             path: '',
             path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
             controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :users, only: [:show] do
    member do
     patch '/update_phone_number' => 'users#update_phone_number'
    end
  end

  resources :motorbikes, except: [:edit] do
    member do
      get 'listing'
      get 'pricing'
      get 'description'
      get 'photo_upload'
      get 'location'
      get 'preload'
      get 'preview'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
    resources :calendars
  end

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]

  get '/your_trips' => 'reservations#your_trips'
  get '/your_reservations' => 'reservations#your_reservations'
  post 'reservations/charge' => 'reservations#charge'

  get 'search' => 'pages#search'

  get 'dashboard' => 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
    post :charge, on: :member
    member do
      post '/approve' => "reservations#approve"
      post '/decline' => "reservations#decline"
    end
  end

<<<<<<< HEAD
  resources :revenues, only: [:index]

=======
>>>>>>> origin/master
  resources :conversations, only: [:index, :create]  do
  resources :messages, only: [:index, :create]
end

<<<<<<< HEAD
  get '/host_calendar' => "calendars#host"
  get '/payment_method' => "users#payment"
  get '/payout_method' => "users#payout"
  post '/add_card' => "users#add_card"

  get '/notifications' => 'notifications#index'

=======
>>>>>>> origin/master
  mount ActionCable.server => '/cable'
end
