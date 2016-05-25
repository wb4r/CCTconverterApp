Rails.application.routes.draw do
  resources :searches, only: [:new, :create]
  root to: "searches#new"
end
