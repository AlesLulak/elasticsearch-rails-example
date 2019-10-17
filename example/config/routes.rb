Rails.application.routes.draw do
  root "people#index"

  resources :people, only: %i[index new create update]

  get "search", to: "search#search"
end
