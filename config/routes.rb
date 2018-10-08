Rails.application.routes.draw do
  get 'resume/index'

  resources :users do
    resources :profiles
  end

  resources :employment_records

  root 'resume#index'
end
