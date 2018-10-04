Rails.application.routes.draw do
  get 'resume/index'

  resources :users
  resources :profiles

  root 'resume#index'
end
