Rails.application.routes.draw do
  get 'resume/index'

  resources :users

  root 'resume#index'
end
