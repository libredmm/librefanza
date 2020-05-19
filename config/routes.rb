Rails.application.routes.draw do
  resources :fanza_items, only: %i[index show create]
  resources :movies, only: %i[index show]
end
