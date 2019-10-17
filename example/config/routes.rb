Rails.application.routes.draw do
  root "persons#index"

  resources :persons

  get "search", to: "search#search"
end
