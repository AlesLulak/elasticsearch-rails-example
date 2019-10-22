Rails.application.routes.draw do
  root "persons#index"

  resources :persons, except: %i[show] do
    patch "archive", on: :member
    # post "add_email", on: :member

    resources :emails
  end

  get "search", to: "search#search"
end
