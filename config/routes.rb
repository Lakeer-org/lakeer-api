Rails.application.routes.draw do
  devise_for :users
  root to: 'admin/dashboard#index'  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :admin do
    get 'dashboard', to: "dashboard#index"
    resources :users
  end
  mount Lakeer::Base::API => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

end
