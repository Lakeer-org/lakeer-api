Rails.application.routes.draw do
  devise_for :users
  root to: 'admin/dashboard#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'restricted-access', to: "admin#restricted_access"
  namespace :admin do
    get 'dashboard', to: "dashboard#index"
    resources :users
    resources :indices
    resources :service_categories
    resources :services
    resources :service_metrics, except: [:destroy]
  end
  mount Base::API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

end
