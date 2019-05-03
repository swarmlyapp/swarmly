Rails.application.routes.draw do
  mount Notifications::Engine => "/notifications"
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'static_pages#home'
  get    'maps'   => 'static_pages#maps'
  get    'login'   => 'static_pages#login'
  get    'lock'   => 'static_pages#lock'
  get "pages/home", to: "pages#home"
  get "conducta", to: 'static_pages#conduct'
  get '.well-known/assetlinks.json' => 'static_pages#assetlinks', :defaults => { :format => 'json' }
  delete 'delete_all', to: 'notes#delete_all'
  get 'mentions', to: 'users#mentions'
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :destroy_user
  resources :categories, except: [:destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :groups do
    resource :like, module: :groups
    resources :favorites
    resources :comments, only: [:create]  
    resources :clips, shallow: true
    resources :zones, shallow: true
    resources :notes, shallow: true do
      resources :photos
      post '/up-vote' => "votes#up_vote", as: :up_vote
      post '/down-vote' => "votes#down_vote", as: :down_vote
    end
  end
  resources :tags
  resources :attachments, only: [:create]
  resources :favorites
  resources :users, except: [:new] do
    member do
      get 'following'
      get 'followers'
    end
  end
  mount ActionCable.server => "/cable"
end
