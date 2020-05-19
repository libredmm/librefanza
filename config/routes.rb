Rails.application.routes.draw do
  root "movies#index"
  resources :movies, only: %i[index show]
  resources :fanza_items, only: %i[index show]
  resources :javlibrary_items, onlu: %i[index show]
  resources :javlibrary_pages, only: %i[index show]
end
