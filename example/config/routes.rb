Rails.application.routes.draw do
  root "persons#index"

  resources :persons do
    patch "archive", on: :member
  end

  get "search", to: "search#search"
end
