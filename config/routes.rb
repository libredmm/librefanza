require "sidekiq/web"

Rails.application.routes.draw do
  root "pages#index"
  get "/search", to: "pages#search"

  resources :movies, only: %i[index show]
  resources :fanza_actresses, only: %i[index show]
  resources :fanza_items, only: %i[index show destroy]
  resources :javlibrary_items, onlu: %i[index show]
  resources :javlibrary_pages, only: %i[index show]

  constraints Clearance::Constraints::SignedIn.new { |user| user.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end
end
