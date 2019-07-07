Rails.application.routes.draw do
  get 'tracks/destroy'
  root 'sites#home'
  get :about, to: 'sites#about'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :projects do
    resources :tracks, only: [:destroy]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
