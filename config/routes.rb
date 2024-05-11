Rails.application.routes.draw do
  devise_for :users
  root to: 'photos#index'
  resources :photos

  get '/photosbycategory/', to: 'photos#photos_by_category', as: 'photos_by_category'
  get '/photosbyproject/', to: 'photos#photos_by_project', as: 'photos_by_project'
end
