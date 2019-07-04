Rails.application.routes.draw do
  devise_for :users
  root 'sites#home'
  get :about, to: 'sites#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
