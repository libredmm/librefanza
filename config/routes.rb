require "sidekiq_unique_jobs/web"

Rails.application.routes.draw do
  root "pages#index"
  get "/search", to: "pages#search"
  get "feeds/pipe"

  resources :movies, only: %i[show]
  resources :fanza_actresses, only: %i[show], path: "actresses"
  resources :fanza_items, only: %i[show]
  resources :javlibrary_items, only: %i[show]
  resources :mgstage_items, only: %i[show]
  resources :sod_items, only: %i[show]

  constraints Clearance::Constraints::SignedIn.new { |user| user.is_admin? } do
    resources :movies, only: %i[index update destroy]
    resources :fanza_actresses, only: %i[index], path: "actresses"
    resources :fanza_items, only: %i[index destroy update]
    resources :javlibrary_items, only: %i[index destroy]
    resources :javlibrary_pages, only: %i[index show new create]
    resources :mgstage_items, only: %i[index destroy]
    resources :mgstage_pages, only: %i[index show]
    resources :sod_items, only: %i[index destroy]
    resources :sod_pages, only: %i[index show]
    resources :feeds, only: %i[index show destroy update]
    mount Sidekiq::Web => "/sidekiq"
  end
end
