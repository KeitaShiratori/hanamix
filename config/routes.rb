Rails.application.routes.draw do
  resources :rounds, only: [:show, :new, :create, :edit, :update, :destroy]

  root to: 'static_pages#home'
  get 'signup', to: 'users#new'
  get    'login'           => 'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users, only: [:show, :new, :create, :edit, :update]
  resources :sessions, only: [:new, :create, :destroy]
  resources :paticipations, only: [] do
    member do
      post 'wish'
      delete 'unwish'
      post 'approve'
    end
  end
  post 'paticipate_now/:round_id' => 'paticipations#now'
  resources :talks do
    member do
      get 'create'
      get 'destroy'
    end
  end
end