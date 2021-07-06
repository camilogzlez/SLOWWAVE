Rails.application.routes.draw do
  devise_for :users
  root to: 'photos#index'
  resources :photos

  get '/photosbycategory/', to: 'photos#photos_by_category', as: 'photos_by_category'
end
