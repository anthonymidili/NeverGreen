Rails.application.routes.draw do
  root 'sites#home'
  get :about, to: 'sites#about'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :projects do
    get 'remove_track/:track_id', as: :remove_track, to: 'projects#remove_track'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
