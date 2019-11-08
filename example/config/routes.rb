Rails.application.routes.draw do
  root "persons#index"

  get "/stats", to: "emails#stats"
  
  resources :persons, except: :show, path: "" do
    patch "archive", on: :member
    resources :emails do
      patch "/add_sent", to: "emails#add_sent", on: :member 
      resources :comments
    end
  end

  get "search", to: "search#search"
end
