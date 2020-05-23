Rails.application.routes.draw do
  root "pages#index"
  get "/search", to: "pages#search"
  get "/whosyourdaddy", to: "pages#whosyourdaddy", as: "godmode"

  resources :movies, only: %i[index show]
  resources :fanza_actresses, only: %i[index show]
  resources :fanza_items, only: %i[index show]
  resources :javlibrary_items, onlu: %i[index show]
  resources :javlibrary_pages, only: %i[index show]
end
