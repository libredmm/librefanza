Rails.application.routes.draw do
  resources :javlibrary_pages, only: %i[index show create]
  resources :fanza_items, only: %i[index show create]
  resources :movies, only: %i[index show]
end
