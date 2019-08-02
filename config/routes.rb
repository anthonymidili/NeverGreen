Rails.application.routes.draw do
  root 'sites#home'
  get :about, to: 'sites#about'

  devise_for :users, controllers: { registrations: 'users/registrations', invitations: 'users/invitations' }

  resources :projects do
    resources :tracks, only: [:destroy] do
      member do
        post :downloaded
      end
    end
  end

  resources :band_members, only: [:index, :destroy]
  delete 'band_members/kickout/:id', as: :band_members_kickout, to: 'band_members#kickout'

  resources :songs
  resources :galleries

  namespace :users do
    resource :timezones, only: [:edit, :update]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
