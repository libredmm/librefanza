Rails.application.routes.draw do
  resources :movies, only: %i[index show]

  resources :fanza_items, only: %i[index show create]

  resources :javlibrary_pages, only: %i[index show create]
  resources :javlibrary_items, onlu: %i[index show]
end
