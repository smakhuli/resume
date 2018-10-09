Rails.application.routes.draw do
  get 'resume/index'

  resources :users do
    resources :profiles
  end

  resources :employment_records
  resources :resume_lists
  resources :references

  root 'resume#index'
end
