Rails.application.routes.draw do
  resources :searches # MODIF LATER
  root to: "searches#new"
end
