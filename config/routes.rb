Rails.application.routes.draw do
  devise_for :users
  resource "settings" do
    put "allow"
    put "block"
  end
  get "search", to: "search#index"
  root "pages#home"
end
