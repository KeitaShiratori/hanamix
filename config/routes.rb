Rails.application.routes.draw do
  get 'balls/create'
  get 'balls/edit'
  get 'balls/delete'
  get 'balls/show'

  resources :rounds do
    member do
      get 'score'
      get 'battle'
    end
  end
  
  root to: 'static_pages#home'
  get 'signup', to: 'users#new'
  get    'login'           => 'sessions#new'
  post   'login'           => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'

  resources :users
  resources :sessions,      only: [:new, :create, :destroy]
end