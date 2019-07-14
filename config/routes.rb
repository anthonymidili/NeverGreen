Rails.application.routes.draw do
  root 'sites#home'
  get :about, to: 'sites#about'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :projects do
    resources :tracks, only: [:destroy] do
      member do
        post :downloaded
      end
    end
  end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
