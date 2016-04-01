Rails.application.routes.draw do
  get 'balls/create'
  get 'balls/edit'
  get 'balls/delete'
  get 'balls/show'

  resources :rounds do
    member do
      get 'show_talk'
      get 'show_wish'
    end
  end
  
  root to: 'static_pages#home'
  get 'signup', to: 'users#new'
  get    'login'           => 'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users do
    member do
      get 'join_list'
      get 'history_list'
    end
  end
  resources :sessions,      only: [:new, :create, :destroy]
  resources :paticipations, only: [      :create, :destroy] do
    member do
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