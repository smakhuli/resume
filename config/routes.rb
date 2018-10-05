Rails.application.routes.draw do
  get 'resume/index'

  resources :users
  resources :profiles
  resources :employment_records

  root 'resume#index'
end
