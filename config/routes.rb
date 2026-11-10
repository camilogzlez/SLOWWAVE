Rails.application.routes.draw do
  namespace :admin do
      resources :categories do
        member do
          patch :reorder_photos
          patch :reorder_subcategories
        end
      end
      resources :subcategories do
        member do
          patch :reorder_photos
          patch :quick_update
        end
      end
      resources :photos do
        collection do
          post :bulk_assign
          delete :bulk_destroy
        end
        member do
          patch :quick_update
        end
      end
      resources :home_tiles, only: %i[create update destroy] do
        collection do
          get :grid
          patch :reorder
        end
      end
      resources :projects do
        member do
          patch :reorder_photos
        end
      end
      resources :users

      root to: "categories#index"
    end
  devise_for :users
  root to: 'photos#index'
  resources :photos
  resources :categories, only: [:show]

  get '/photosbycategory/', to: 'photos#photos_by_category', as: 'photos_by_category'
  get '/photosbyproject/', to: 'photos#photos_by_project', as: 'photos_by_project'
  get '/photosbysubcategory/:id', to: 'photos#photos_by_subcategory', as: 'photos_by_subcategory'
  get 'about', to: 'pages#about'
end
