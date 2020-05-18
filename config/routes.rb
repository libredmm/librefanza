Rails.application.routes.draw do
  resources :fanza_items, except: %i[edit update]
end
