Rails.application.routes.draw do
  devise_for :users
  get "search", to: "search#index"
  root "pages#home"
end
