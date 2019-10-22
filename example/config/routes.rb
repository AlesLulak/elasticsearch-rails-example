Rails.application.routes.draw do
  root "persons#index"

  resources :persons, except: :show, path: "" do
    patch "archive", on: :member
    resources :emails
  end

  get "search", to: "search#search"
end
