Rails.application.routes.draw do
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  get 'resume/index'
  get "/resumes" => "users#index"

  resources :users do
    resources :profiles
    member do
      get "show_resume"
      get "generate_pdf"
    end
  end

  resources :employment_records
  resources :resume_lists
  resources :references
  resources :messages

  root "users#index"
end
